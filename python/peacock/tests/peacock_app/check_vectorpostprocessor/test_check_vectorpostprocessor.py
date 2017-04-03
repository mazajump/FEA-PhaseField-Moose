#!/usr/bin/env python
from peacock.utils import Testing

class Tests(Testing.PeacockTester):
    def setUp(self):
        super(Tests, self).setUp()
        self.filename = "check_vectorpostprocessor.png"
        Testing.remove_file(self.filename)
        Testing.clean_files()

    def testRunResult(self):
        args = ["../../common/time_data.i", Testing.find_moose_test_exe()]
        app = self.createPeacockApp(args)
        exe_plugin = app.main_widget.tab_plugin.ExecuteTabPlugin
        vpp_plugin = app.main_widget.tab_plugin.VectorPostprocessorViewer
        # issue #129
        # Running multiple times caused it to crash
        exe_plugin.ExecuteOptionsPlugin.csv_checkbox.setChecked(False)
        for i in range(10):
            exe_plugin.ExecuteRunnerPlugin.runClicked()

            app.main_widget.tab_plugin.setCurrentWidget(vpp_plugin)
            app.main_widget.tab_plugin.currentChanged.emit(app.main_widget.tab_plugin.currentIndex())

            # make sure we are finished
            while not self.finished:
                self.qapp.processEvents()
            Testing.process_events(self.qapp, t=3)

            self.assertEqual(vpp_plugin.count(), 1)
            w = vpp_plugin.currentWidget()
            self.assertEqual(len(w.PostprocessorSelectPlugin._groups), 1)
            self.assertEqual(len(w.PostprocessorSelectPlugin._groups[0]._toggles), 7)

if __name__ == '__main__':
    Testing.run_tests()
