      SUBROUTINE UPDATE
      IMPLICIT NONE
      CHARACTER*1 ST9
      CHARACTER*4 ST0,ST1
      INTEGER I,J,M,N
c      INCLUDE 'model.txt'
c      INCLUDE 'setcon.txt'
C*****model.txt
      INTEGER PFI,ARP,VRI,CCV,LYAP,SCC,fct
      DOUBLE PRECISION SCALE,VR,CONST,PHI(20),PRDG
      COMMON/MODEL/SCALE,VR,CONST,PHI,PRDG,PFI,ARP,VRI,CCV,LYAP,SCC,fct
      integer for, fty
      common/model/for, fty
      integer ARI, tra
      common/model/ari,tra
             
C*****setcon.txt
      LOGICAL CONV,FAIL
      INTEGER NP,ITCT,PPIND
      DOUBLE PRECISION CSO,CSZ,LAM,SSOLD,GMOLD,GMNEW,SIGSQ,OLDB(22)
c      COMMON/SETCON/CONV,FAIL,NP,ITCT,PPIND,CSO,CSZ,LAM,SSOLD,
c     *GMOLD,GMNEW,SIGSQ,OLDB
      COMMON/SETCON/CSO,CSZ,LAM,SSOLD,
     *GMOLD,GMNEW,SIGSQ,OLDB,CONV,FAIL,NP,ITCT,PPIND

      if(tra.EQ.1)then
C      PRINT *,'MODEL UPDATE IN PROGRESS'
      end if
      I=ARP+1
C        IF(I.GT.20)THEN
C          PRINT *,'PROGRAM FAILS: MAXIMUM ORDER EXCEEDED IN UPDATE'
C          STOP
C        END IF
c        OPEN(UNIT=4,FILE='newmodel.dat',STATUS='unknown')
        ST0='PFI='
        IF(PFI.EQ.1)THEN
          ST1='QLFA'
        ELSE IF(PFI.EQ.2)THEN
          ST1='QLFS'
        ELSE IF(PFI.EQ.3)THEN
          ST1='DIRA'
        ELSE IF(PFI.EQ.4)THEN
          ST1='DIRS'
        ELSE IF(PFI.EQ.5)THEN
          ST1='MAPA'
        ELSE
          ST1='MAPS'
        END IF
c        WRITE(4,100)ST0,ST1
c  100   FORMAT(2A4)
        ST0='SCA='
c        WRITE(4,101)ST0,SCALE
c  101   FORMAT(A4,D14.6)
        ST0='ARP='
c        WRITE(4,102)ST0,I
c  102   FORMAT(A4,I3)
        ST0='ARI='
        ST9='Y'
c        WRITE(4,103)ST0,ST9
c  103   FORMAT(A4,A1)
        DO 200 J=1,ARP
        PHI(J)=OLDB(J)
  200   CONTINUE
        IF(PFI.EQ.1)THEN
C         TO BE DEFINED LATER
        ELSE IF(PFI.EQ.2)THEN
C         TO BE DEFINED LATER
        ELSE IF(PFI.EQ.3.OR.PFI.EQ.4)THEN
          PHI(I)=PHI(ARP)*SCALE
          DO 201 J=2,ARP
          M=ARP-J
          N=M+2
          PHI(N)=PHI(N)+PHI(M+1)*SCALE
  201     CONTINUE
          PHI(1)=PHI(1)+SCALE
        ELSE
          PHI(I)=CSZ
        END IF
        DO 202 J=1,I
c        WRITE(4,104)PHI(J)
c  104   FORMAT(D14.6)
  202   CONTINUE
        ST0='VRI='
        IF(VRI.EQ.0)THEN
          ST9='N'
        ELSE
          ST9='Y'
        END IF
c        WRITE(4,103)ST0,ST9
        IF(VRI.EQ.1)THEN
c          WRITE(4,104)VR
        END IF
        ST0='CCV='
        IF(CCV.EQ.0)THEN
          ST1='NULL'
        ELSE IF(CCV.EQ.1)THEN
          ST1='MNCT'
        ELSE
          ST1='CTES'
        END IF
c       WRITE(4,100)ST0,ST1
c        CLOSE(UNIT=4)
      RETURN
      END
