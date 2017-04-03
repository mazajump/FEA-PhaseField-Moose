C
      SUBROUTINE CREEP(DECRA,DESWA,STATEV,SERD,EC,ESW,P,QTILD,
     1     TEMP,DTEMP,PREDEF,DPRED,TIME,DTIME,CMNAME,LEXIMP,LEND,
     2     COORDS,NSTATV,NOEL,NPT,LAYER,KSPT,KSTEP,KINC)
C
C      INCLUDE 'ABA_PARAM.INC'
C
      CHARACTER*8 CMNAME
C
      DIMENSION DECRA(5),DESWA(5),STATEV(*),PREDEF(*),DPRED(*),TIME(2),
     1     COORDS(*),EC(2),ESW(2)
C
      DO 3 KK=1,5
 3       DECRA(KK)=0.D0
         IF(QTILD.LT.100.) GO TO 10
         A=2.5E-27
         XN=5.
         XM=-.2
         C1=1./(1.+XM)
         IF(CMNAME.EQ.'A4')GO TO 5
C     TIME HARDENING
         TERM1=A*QTILD**XN*C1
         DECRA(1)=TERM1*(TIME(1)**(1.+XM)-(TIME(1)-DTIME)**(1.+XM))
         IF (LEXIMP.EQ.1) THEN
            IF (QTILD.EQ.0.0) THEN
               DECRA(5) = 0.0
            ELSE
               DECRA(5)=DECRA(1)*XN/QTILD
            END IF
         END IF
         GO TO 10
 5       CONTINUE
C     STRAIN HARDENING
         EC0=EC(1)
         TERM1=(A*QTILD**XN*C1)**C1
         TERM2=TERM1*DTIME+EC0**C1
         IF (TERM1.EQ.0.0) THEN
            STATEV(1) = 0.0
         ELSE
            STATEV(1)=TERM2/TERM1
         END IF
         STATEV(2)=EC(2)
         DECRA(1)=(TERM2**(1.+XM)-EC0)
         IF (LEXIMP.EQ.1) THEN
            IF (QTILD.EQ.0.0) THEN
               DECRA(5) = 0.0
            ELSE
               DECRA(5)=XN*DTIME*TERM2**XM*TERM1/QTILD
            END IF
         END IF
 10      CONTINUE
C
C     PRINT *, DECRA
         RETURN
         END
