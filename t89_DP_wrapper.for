      SUBROUTINE T89_V(iopt, ps, X, Y, Z, Bx, By, Bz, n)

        dimension parmod(10)
        REAL*8 ps, X(n), Y(n), Z(n), BX(n), BY(n), BZ(n)
        INTEGER N, iopt
!f2py intent(in) :: X, Y, Z, ps, iopt
!f2py intent(out) :: BX, BY, BZ
!f2py intent(hide) :: n

        DO i=1, N
          CALL T89D_DP (iopt, parmod, ps, X(i), Y(i), Z(i),
     &Bx(i), By(i), Bz(i))
        END DO
        RETURN

      END
