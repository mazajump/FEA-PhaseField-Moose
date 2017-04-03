#!/usr/bin/python
import os, sys, getopt

try:
    from PyQt4 import QtCore, QtGui
    QtCore.Signal = QtCore.pyqtSignal
    QtCore.Slot = QtCore.pyqtSlot
except ImportError:
    try:
        from PySide import QtCore, QtGui
        QtCore.QString = str
    except ImportError:
        raise ImportError("Cannot load either PyQt or PySide")


from OptionsGUI import OptionsGUI
from GenSyntax import *
from ActionSyntax import *
from ParamTable import *
from CommentEditor import *

import MeshInfoFactory

from readInputFile import readInputFile, GPNode

try:
    _fromUtf8 = QtCore.QString.fromUtf8
except AttributeError:
    _fromUtf8 = lambda s: s

class InputFileTreeWidget(QtGui.QTreeWidget):
    tree_changed = QtCore.Signal()
    mesh_item_changed = QtCore.Signal(QtGui.QTreeWidgetItem)
    def __init__(self, input_file_widget, win_parent=None):
        QtGui.QTreeWidget.__init__(self, win_parent)

        self.comment = ''

        self.input_file_widget = input_file_widget
        self.application = self.input_file_widget.application
        self.action_syntax = self.input_file_widget.action_syntax

        self.setExpandsOnDoubleClick(False)
        self.setMinimumWidth(200)
        self.setContextMenuPolicy(QtCore.Qt.CustomContextMenu)
        self.connect(self,QtCore.SIGNAL('customContextMenuRequested(QPoint)'), self._newContext)
        self.addHardPathsToTree()

        self.header().close()

        QtCore.QObject.connect(self,
                               QtCore.SIGNAL("itemDoubleClicked(QTreeWidgetItem *, int)"),
                               self._doubleClickedItem)

        QtCore.QObject.connect(self,
                               QtCore.SIGNAL("itemChanged(QTreeWidgetItem*, int)"),
                               self._itemChanged)

        QtCore.QObject.connect(self,
                               QtCore.SIGNAL("currentItemChanged(QTreeWidgetItem*, QTreeWidgetItem*)"),
                               self._currentItemChanged)

    def addHardPathsToTree(self):
        # Add every hard path
        for path in self.action_syntax.hard_paths:
            self._recursivelyAddTreeItems(path.split('/'), self)

    def loadData(self, counter, progress, main_sections):
        QtCore.QObject.disconnect(self, QtCore.SIGNAL("itemChanged(QTreeWidgetItem*, int)"), self._itemChanged)

        progress.setMaximum(counter+len(main_sections))

        for section_name, section_node in main_sections.items():
            counter+=1
            progress.setValue(counter)
            self._addDataRecursively(self, section_node)

        self.addHardPathsToTree() # We do this here because * paths might add more paths underneath some of the paths
        self._updateOtherGUIElements()
        QtCore.QObject.connect(self, QtCore.SIGNAL("itemChanged(QTreeWidgetItem*, int)"), self._itemChanged)

    def generatePathFromItem(self, item):
        from_parent = ''
        if item.parent():
            from_parent = self.generatePathFromItem(item.parent())

        return from_parent + '/' + str(item.text(0))

    ''' Looks for a child item of parent named "name"... with return None if there is no child named that '''
    def findChildItemWithName(self, parent, name):
        try: # This will fail when we're dealing with the QTreeWidget itself
            num_children = parent.childCount()
        except:
            num_children = parent.topLevelItemCount()

        for i in range(num_children):
            child = None
            try: # This will fail when we're dealing with the QTreeWidget itself
                child = parent.child(i)
            except:
                child = parent.topLevelItem(i)

            if child.text(0) == name:
                return child

        return None

    def getMeshItemData(self):
        mesh_item = self.findChildItemWithName(self, 'Mesh')
        data = None
        try:
            return mesh_item.table_data
        except:
            pass

        return None

    def getMeshFileName(self):
        mesh_data = self.getMeshItemData()
        if mesh_data:
            if 'file' in mesh_data:
                return mesh_data['file']
        else:
            return None

    def getOutputItemData(self):
        output_item = self.findChildItemWithName(self, 'Outputs')
        data = None
        try:
            return output_item.table_data
        except:
            pass

        return None

    ##
    # Initialize the list of output file and block names (private)
    # This function initializes self._output_file_names and self._output_block_names
    def getOutputFileAndBlockNames(self):

        # Storage for file_base as a common parameter
        common_file_base = ''
        output_file_names = []
        output_block_names = []

        # Find the Outputs block items and the names of the sub-blocks
        outputs = self.findChildItemWithName(self, 'Outputs')
        outputs_children = self.getChildNames(outputs)

        # Check for short-cut syntax (i.e., exodus = true)
        # Make sure that the node has table_data before going on...not all do!
        if hasattr(outputs, 'table_data'):
            output_data = outputs.table_data

            if 'file_base' in output_data:
                common_file_base = output_data['file_base']
            else:
                common_file_base = 'peacock_run_tmp'

            # Check for short-cut syntax (i.e., exodus = true)
            if outputs.table_data and 'exodus' in outputs.table_data and outputs.table_data['exodus'] == 'true':
                if common_file_base == 'peacock_run_tmp':
                    output_file_names.append(common_file_base + '_out.e')
                else:
                    output_file_names.append(common_file_base + '.e')
                output_block_names.append('exodus')

            # Loop through each of the sub-blocks and grab the data, if type = Exodus
            for item in outputs_children:

                # Extract the data for the sub-block
                child = self.findChildItemWithName(outputs, item)
                output_data = child.table_data

                # If the object is active (checked), it contains output_data, and is of type = Exodus, then extract the filename
                if child.checkState(0) > 0 and ('type' in output_data) and (output_data['type'] == 'Exodus'):
                    file_base = common_file_base + "_" + output_data['Name']

                    # Check for file_base
                    if ('file_base' in output_data) and (output_data['file_base'] != ''):
                        file_base = output_data['file_base']

                    # Check for oversampling and appending of '_oversample'
                    if ('oversample' in output_data) and (output_data['oversample'] != '0') and ('append_oversample' in output_data) and (output_data['oversample'] != '0'):
                        file_base = file_base + '_oversample'

                    # Append the file_base and object name to the lists
                    output_file_names.append(file_base + '.e')
                    output_block_names.append(output_data['Name'])

        # FIXME: Hack to make raven and r7 work for now
        if 'raven' in self.input_file_widget.app_path or 'r7' in self.input_file_widget.app_path:
            output_file_names = [common_file_base + '_displaced.e']
            output_block_names = ['']

        # Return the list of file and block names
        return [output_file_names, output_block_names]

    def _itemHasEditableParameters(self, item):
        this_path = self.generatePathFromItem(item)
        this_path = '/' + self.action_syntax.getPath(this_path) # Get the real action path associated with this item
        yaml_entry = self.input_file_widget.yaml_data.findYamlEntry(this_path)
        has_type_subblock = False
        if 'subblocks' in yaml_entry and yaml_entry['subblocks']:
            for sb in yaml_entry['subblocks']:
                if '<type>' in sb['name']:
                    has_type_subblock = True

        if ('parameters' in yaml_entry and yaml_entry['parameters'] != None) or has_type_subblock or this_path == '/GlobalParams':
            return True

    def _addDataRecursively(self, parent_item, node):
        is_active = 'active' not in node.parent.params or node.name in node.parent.params['active'].split(' ')

        table_data = node.params
        table_data['Name'] = node.name

        param_comments = node.param_comments

        comment = '\n'.join(node.comments)

        new_child = self.findChildItemWithName(parent_item, table_data['Name'])

        if not new_child:  # If we didn't find a child that already matched then create a new child
            new_child = QtGui.QTreeWidgetItem(parent_item)
            new_child.setText(0,table_data['Name'])
#      parent_item.addChild(new_child)
            new_child.table_data = {}
            new_child.param_comments = []
            new_child.comment = ''


        has_params = False
        # See if there are any actual parameters for this item
        for name,value in node.params.items():
            if name != 'active':
                has_params = True

        if has_params:
            new_child.table_data = copy.deepcopy(table_data)
            if 'active' in new_child.table_data:
                del new_child.table_data['active']
            new_child.param_comments = param_comments

        new_child.comment = comment

        new_child.setFlags(QtCore.Qt.ItemIsSelectable | QtCore.Qt.ItemIsEnabled | QtCore.Qt.ItemIsUserCheckable)

        if is_active:
            new_child.setCheckState(0, QtCore.Qt.Checked)
        else:
            new_child.setCheckState(0, QtCore.Qt.Unchecked)

        if new_child.text(0) == 'Mesh':
            if 'type' not in new_child.table_data:
                new_child.table_data['type'] = 'FileMesh'
            self.mesh_item_changed.emit(new_child)

        if new_child.text(0) == 'Problem':
            if 'type' not in new_child.table_data:
                new_child.table_data['type'] = 'FEProblem'

        for child, child_node in node.children.items():
            self._addDataRecursively(new_child, child_node)

    def _recursivelyAddTreeItems(self, split_path, parent):
        this_piece = split_path[0]

        this_item = None
        found_it = False
        is_star = False

        if this_piece == '*':
            found_it = True
            is_star = True

        num_children = 0

        try: # This will fail when we're dealing with the QTreeWidget itself
            num_children = parent.childCount()
        except:
            num_children = parent.topLevelItemCount()

        for i in range(num_children):
            child = None
            try: # This will fail when we're dealing with the QTreeWidget itself
                child = parent.child(i)
            except:
                child = parent.topLevelItem(i)

            if child.text(0) == this_piece:
                this_item = child
                found_it = True

        if not found_it:
            # Add it
            this_item = QtGui.QTreeWidgetItem(parent)
            this_item.setFlags(QtCore.Qt.ItemIsSelectable | QtCore.Qt.ItemIsEnabled | QtCore.Qt.ItemIsUserCheckable)
            this_item.setCheckState(0, QtCore.Qt.Unchecked)
            this_item.setText(0, this_piece)
            this_item.table_data = {}
            this_item.param_comments = []
            this_item.comment = ''

            this_path = self.generatePathFromItem(this_item)
            if self.action_syntax.hasStar(this_path):
                this_item.setForeground(0, QtCore.Qt.blue)

        if len(split_path) > 1:
            if not is_star:
                self._recursivelyAddTreeItems(split_path[1:], this_item)
            else: # If it is a star and there are children - then add it to all of the children
                for i in range(num_children):
                    child = None
                    try: # This will fail when we're dealing with the QTreeWidget itself
                        child = parent.child(i)
                    except:
                        child = parent.topLevelItem(i)
                    self._recursivelyAddTreeItems(split_path[1:], child)

    def getChildNames(self, parent):
        if not parent:
            return []

        try: # This will fail when we're dealing with the QTreeWidget itself
            num_children = parent.childCount()
        except:
            num_children = parent.topLevelItemCount()

        children_names = []

        for i in range(num_children):
            child = None
            try: # This will fail when we're dealing with the QTreeWidget itself
                child = parent.child(i)
            except:
                child = parent.topLevelItem(i)

            children_names.append(child.text(0))

        return children_names

    def getChildNamesOfPathRecurse(self, current_item, path_pieces):
        if not len(path_pieces):
            children = self.getChildNames(current_item)

            if not children:
                return []

            return children

        next_item = self.findChildItemWithName(current_item, path_pieces[0])

        if not next_item:
            return []

        return self.getChildNamesOfPathRecurse(next_item, path_pieces[1:])

    ''' Pass in a path, get out the children names underneath that path
        Will return an empty list on failure '''
    def getChildNamesOfPath(self, path):
        path_pieces = path.strip('/').split('/')
        return self.getChildNamesOfPathRecurse(self, path_pieces)

    def _doubleClickedItem(self, item, column):
        # Make sure the syntax is up to date
        self.input_file_widget.recache()

        this_path = self.generatePathFromItem(item)

        if not self.action_syntax.isPath(this_path) or self._itemHasEditableParameters(item):
            already_had_data = False
            try:
                item.table_data # If this fails we will jump to "except"...
            except:
                item.table_data = None

            parent_path = ''

            this_path_is_hard = False

            if self.action_syntax.isPath(this_path):
                this_path_is_hard = True
                this_path = '/' + self.action_syntax.getPath(this_path) # Get the real action path associated with this item
                parent_path = this_path
            else:
                parent_path = self.generatePathFromItem(item.parent())
                parent_path = '/' + self.action_syntax.getPath(parent_path)
            yaml_entry = self.input_file_widget.yaml_data.findYamlEntry(parent_path)

            global_params = {}
            global_params_item = self.findChildItemWithName(self, 'GlobalParams')

            # Don't pass in global_params for the GlobalParams block!
            if global_params_item and 'GlobalParams' not in this_path:
                global_params = global_params_item.table_data

            # Hack!
            if 'Outputs' in this_path:
                new_gui = OptionsGUI(yaml_entry, self.action_syntax, item.text(column), item.table_data, item.param_comments, item.comment, False, self.application.typeOptions(), global_params, this_path_is_hard)
            else:
                new_gui = OptionsGUI(yaml_entry, self.action_syntax, item.text(column), item.table_data, item.param_comments, item.comment, False, self.application.typeOptions(), global_params, False)


            if item.table_data:
                new_gui.incoming_data = item.table_data

            if new_gui.exec_():
                item.table_data = new_gui.result()
                item.param_comments = new_gui.param_table.param_comments
                item.comment = new_gui.param_table.comment
                if not self.action_syntax.isPath(this_path):  # Don't change the name of hard paths
                    item.setText(0,item.table_data['Name'])
                item.setCheckState(0, QtCore.Qt.Checked)
                if item.text(0) == 'Mesh':
                    self.mesh_item_changed.emit(item)
                self._updateOtherGUIElements()

    def _itemChanged(self, item, column):
        self._updateOtherGUIElements()

    def _deleteCurrentItem(self):
        item = self.currentItem()
        parent = item.parent()
        if parent:
            parent.removeChild(item)
        else: #Must be a top level item
            self.removeItemWidget(item, 0)
        self.addHardPathsToTree() # We do this here because they might have removed a hard path... but there is no way to get them back
        self._updateOtherGUIElements()

    def _editComment(self):
        item = self.currentItem()
        ce = CommentEditor(item)
        if ce.exec_():
            self._itemChanged(item, 0)

    def _addItem(self):
        # Make sure the syntax is up to date
        self.input_file_widget.recache()

        item = self.currentItem()
        this_path = self.generatePathFromItem(item)
        this_path = '/' + self.action_syntax.getPath(this_path) # Get the real action path associated with this item
        yaml_entry = self.input_file_widget.yaml_data.findYamlEntry(this_path)

        global_params = {}
        global_params_item = self.findChildItemWithName(self, 'GlobalParams')

        if global_params_item:
            global_params = global_params_item.table_data

        self.new_gui = OptionsGUI(yaml_entry, self.action_syntax, item.text(0), None, None, None, False, self.application.typeOptions(), global_params, False)
        if self.new_gui.exec_():
            table_data = self.new_gui.result()
            param_comments = self.new_gui.param_table.param_comments
            comment = self.new_gui.param_table.comment
            new_child = QtGui.QTreeWidgetItem(item)
            new_child.setText(0,table_data['Name'])
            new_child.table_data = table_data
            new_child.param_comments = param_comments
            new_child.comment = comment
            new_child.setFlags(QtCore.Qt.ItemIsSelectable | QtCore.Qt.ItemIsEnabled | QtCore.Qt.ItemIsUserCheckable)
            new_child.setCheckState(0, QtCore.Qt.Checked)
            item.addChild(new_child)
            item.setCheckState(0, QtCore.Qt.Checked)
            item.setExpanded(True)
            self.setCurrentItem(new_child)

            if item.text(0) == 'Mesh':
                self.mesh_item_changed.emit(item)

            self._updateOtherGUIElements()
            self.addHardPathsToTree() # We do this here because * paths might add more paths underneath the item we just added

    def _newContext(self, pos):
        global_pos = self.mapToGlobal(pos)
        item = self.itemAt(pos)
        this_path = self.generatePathFromItem(item)

        menu = QtGui.QMenu(self)

        # Don't allow deletion of hard paths
        if self.action_syntax.hasStar(this_path): # If it is a hard path allow them to add a child
            add_action = QtGui.QAction("Add...", self)
            add_action.triggered.connect(self._addItem)
            menu.addAction(add_action)
        else:
            delete_action = QtGui.QAction("Delete", self)
            delete_action.triggered.connect(self._deleteCurrentItem)
            menu.addAction(delete_action)

        comment_action = QtGui.QAction("Edit Comment...", self)
        comment_action.triggered.connect(self._editComment)
        menu.addAction(comment_action)

        menu.popup(global_pos)

    def _updateOtherGUIElements(self):
        self.tree_changed.emit()
        self.input_file_widget.input_file_textbox.updateTextBox()

        # Update the output selection box (TODO: This only needs to run when [Outputs] is changed)
        if hasattr(self.application.main_window, "visualize_widget"):
            self._output_file_names = []
            self._output_block_names = []
            self.application.main_window.visualize_widget.updateOutputControl()

    def _currentItemChanged(self, current, previous):
        if not current:
            return

        if 'boundary' in current.table_data:
            self.input_file_widget.mesh_render_widget.highlightBoundary(current.table_data['boundary'])
        elif 'master' in current.table_data:
            if 'slave' in current.table_data:
                self.input_file_widget.mesh_render_widget.highlightBoundary(current.table_data['master']+' '+current.table_data['slave'])
        elif 'block' in current.table_data:
            self.input_file_widget.mesh_render_widget.highlightBlock(current.table_data['block'])
        elif previous and hasattr(previous, 'table_data') and ('boundary' in previous.table_data or 'block' in previous.table_data or ('master' in previous.table_data and 'slave' in previous.table_data)):
            self.input_file_widget.mesh_render_widget.clearHighlight()
