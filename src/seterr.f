      SUBROUTINE SETERR(MESSG,NMESSG,NERR,IOPT)
C
C  SETERR SETS LERROR = NERR, OPTIONALLY PRINTS THE MESSAGE AND DUMPS
C  ACCORDING TO THE FOLLOWING RULES...
C
C    IF IOPT = 1 AND RECOVERING      - JUST REMEMBER THE ERROR.
C    IF IOPT = 1 AND NOT RECOVERING  - PRINT AND STOP.
C    IF IOPT = 2                     - PRINT, DUMP AND STOP.
C
C  INPUT
C
C    MESSG  - THE ERROR MESSAGE.
C    NMESSG - THE LENGTH OF THE MESSAGE, IN CHARACTERS.
C    NERR   - THE ERROR NUMBER. MUST HAVE NERR NON-ZERO.
C    IOPT   - THE OPTION. MUST HAVE IOPT=1 OR 2.
C
C  ERROR STATES -
C
C    1 - MESSAGE LENGTH NOT POSITIVE.
C    2 - CANNOT HAVE NERR=0.
C    3 - AN UNRECOVERED ERROR FOLLOWED BY ANOTHER ERROR.
C    4 - BAD VALUE FOR IOPT.
C
C  ONLY THE FIRST 72 CHARACTERS OF THE MESSAGE ARE PRINTED.
C
C  THE ERROR HANDLER CALLS A SUBROUTINE NAMED SDUMP TO PRODUCE A
C  SYMBOLIC DUMP.
C
C/6S
C     INTEGER MESSG(1)
C/7S
      CHARACTER*1 MESSG(NMESSG)
C/
C
C  THE UNIT FOR ERROR MESSAGES.
C
      IWUNIT=I1MACH(4)
C
      IF (NMESSG.GE.1) GO TO 10
C
C  A MESSAGE OF NON-POSITIVE LENGTH IS FATAL.
C
c        WRITE(IWUNIT,9000)
c 9000   FORMAT(52H1ERROR    1 IN SETERR - MESSAGE LENGTH NOT POSITIVE.)
        call rwarn('1 IN SETERR - MESSAGE LENGTH NOT POSITIVE.')
        GO TO 60
C
C  NW IS THE NUMBER OF WORDS THE MESSAGE OCCUPIES.
C  (I1MACH(6) IS THE NUMBER OF CHARACTERS PER WORD.)
C
C/6S
C10   NW=(MIN0(NMESSG,72)-1)/I1MACH(6)+1
C/7S
 10   NW= MIN0(NMESSG,72)
C/
C
      IF (NERR.NE.0) GO TO 20
C
C  CANNOT TURN THE ERROR STATE OFF USING SETERR.
C  (I8SAVE SETS A FATAL ERROR HERE.)
C
c        WRITE(IWUNIT,9001)
c 9001   FORMAT(42H1ERROR    2 IN SETERR - CANNOT HAVE NERR=0//
c     1         34H THE CURRENT ERROR MESSAGE FOLLOWS///)
        call rwarn('2 IN SETERR - CANNOT HAVE NERR=0.
     1         34H THE CURRENT ERROR MESSAGE FOLLOWS///')
        CALL E9RINT(MESSG,NW,NERR,.TRUE.)
        ITEMP=I8SAVE(1,1,.TRUE.)
        GO TO 50
C
C  SET LERROR AND TEST FOR A PREVIOUS UNRECOVERED ERROR.
C
 20   IF (I8SAVE(1,NERR,.TRUE.).EQ.0) GO TO 30
C
C        WRITE(IWUNIT,9002)
c 9002   FORMAT(23H1ERROR    3 IN SETERR -,
c     1         48H AN UNRECOVERED ERROR FOLLOWED BY ANOTHER ERROR.//
c     2         48H THE PREVIOUS AND CURRENT ERROR MESSAGES FOLLOW.///)
        call rwarn('3 IN SETERR -,
     1         48H AN UNRECOVERED ERROR FOLLOWED BY ANOTHER ERROR.//
     2         48H THE PREVIOUS AND CURRENT ERROR MESSAGES FOLLOW.///')
        CALL EPRINT
        CALL E9RINT(MESSG,NW,NERR,.TRUE.)
        GO TO 50
C
C  SAVE THIS MESSAGE IN CASE IT IS NOT RECOVERED FROM PROPERLY.
C
 30   CALL E9RINT(MESSG,NW,NERR,.TRUE.)
C
      IF (IOPT.EQ.1 .OR. IOPT.EQ.2) GO TO 40
C
C  MUST HAVE IOPT = 1 OR 2.
C
c        WRITE(IWUNIT,9003)
c 9003   FORMAT(42H1ERROR    4 IN SETERR - BAD VALUE FOR IOPT//
c     1         34H THE CURRENT ERROR MESSAGE FOLLOWS///)
         call rwarn('4 IN SETERR - BAD VALUE FOR IOPT//
     1         34H THE CURRENT ERROR MESSAGE FOLLOWS///')
        GO TO 50
C
C  IF THE ERROR IS FATAL, PRINT, DUMP, AND STOP
C
 40   IF (IOPT.EQ.2) GO TO 50
C
C  HERE THE ERROR IS RECOVERABLE
C
C  IF THE RECOVERY MODE IS IN EFFECT, OK, JUST RETURN
C
      IF (I8SAVE(2,0,.FALSE.).EQ.1) RETURN
C
C  OTHERWISE PRINT AND STOP
C
      CALL EPRINT
c      STOP
      call rexit('ERROR IS FATAL')
C
 50   CALL EPRINT
 60   CALL SDUMP
      call rexit('ERROR IS FATAL')
c      STOP
C
      END