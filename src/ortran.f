*UPTODATE ORTRANTEXT
      SUBROUTINE ORTRAN(NM,N,LOW,IGH,A,ORT,Z)
C
C     .. Scalar Arguments ..
      INTEGER IGH,LOW,N,NM
C     .. Array Arguments ..
      DOUBLE PRECISION A(NM,IGH),ORT(IGH),Z(NM,N)
C     .. Local Scalars ..
      DOUBLE PRECISION G
      INTEGER I,J,KL,MM,MP,MP1
C     .. Executable Statements ..
C
C     THIS SUBROUTINE IS A TRANSLATION OF THE ALGOL PROCEDURE ORTRANS,
C     NUM. MATH. 16, 181-204(1970) BY PETERS AND WILKINSON.
C     HANDBOOK FOR AUTO. COMP., VOL.II-LINEAR ALGEBRA, 372-395(1971).
C
C     THIS SUBROUTINE ACCUMULATES THE ORTHOGONAL SIMILARITY
C     TRANSFORMATIONS USED IN THE REDUCTION OF A REAL GENERAL
C     MATRIX TO UPPER HESSENBERG FORM BY  ORTHES.
C
C     ON INPUT-
C
C        NM MUST BE SET TO THE ROW DIMENSION OF TWO-DIMENSIONAL
C          ARRAY PARAMETERS AS DECLARED IN THE CALLING PROGRAM
C          DIMENSION STATEMENT,
C
C        N IS THE ORDER OF THE MATRIX,
C
C        LOW AND IGH ARE INTEGERS DETERMINED BY THE BALANCING
C          SUBROUTINE  BALANC.  IF  BALANC  HAS NOT BEEN USED,
C          SET LOW=1, IGH=N,
C
C        A CONTAINS INFORMATION ABOUT THE ORTHOGONAL TRANS-
C          FORMATIONS USED IN THE REDUCTION BY  ORTHES
C          IN ITS STRICT LOWER TRIANGLE,
C
C        ORT CONTAINS FURTHER INFORMATION ABOUT THE TRANS-
C          FORMATIONS USED IN THE REDUCTION BY  ORTHES.
C          ONLY ELEMENTS LOW THROUGH IGH ARE USED.
C
C     ON OUTPUT-
C
C        Z CONTAINS THE TRANSFORMATION MATRIX PRODUCED IN THE
C          REDUCTION BY  ORTHES,
C
C        ORT HAS BEEN ALTERED.
C
C     QUESTIONS AND COMMENTS SHOULD BE DIRECTED TO B. S. GARBOW,
C     APPLIED MATHEMATICS DIVISION, ARGONNE NATIONAL LABORATORY
C
C     ------------------------------------------------------------------
C
C     ********** INITIALIZE Z TO IDENTITY MATRIX **********
      DO 40 I = 1,N
C
          DO 20 J = 1,N
              Z(I,J) = 0.0D0
   20     CONTINUE
C
          Z(I,I) = 1.0D0
   40 CONTINUE
C
      KL = IGH - LOW - 1
      IF (KL.LT.1) GO TO 160
C     ********** FOR MP=IGH-1 STEP -1 UNTIL LOW+1 DO -- **********
      DO 140 MM = 1,KL
          MP = IGH - MM
          IF (A(MP,MP-1).EQ.0.0D0) GO TO 140
          MP1 = MP + 1
C
          DO 60 I = MP1,IGH
              ORT(I) = A(I,MP-1)
   60     CONTINUE
C
          DO 120 J = MP,IGH
              G = 0.0D0
C
              DO 80 I = MP,IGH
                  G = G + ORT(I)*Z(I,J)
   80         CONTINUE
C     ********** DIVISOR BELOW IS NEGATIVE OF H FORMED IN ORTHES.
C                DOUBLE DIVISION AVOIDS POSSIBLE UNDERFLOW **********
              G = (G/ORT(MP))/A(MP,MP-1)
C
              DO 100 I = MP,IGH
                  Z(I,J) = Z(I,J) + G*ORT(I)
  100         CONTINUE
C
  120     CONTINUE
C
  140 CONTINUE
C
  160 RETURN
C     ********** LAST CARD OF ORTRAN **********
      END