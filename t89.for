
c
c  The small main program below is an example of how to compute field
c   components with T89d_DP.
c    See GEOPACK-2008.doc for a sample field line tracing program.
c
C      implicit real*8 (a-h,o-z)
C      dimension parmod(10)
C  1    print *, '  enter x,y,z,ps,iopt'
C      read*, x,y,z,ps,iopt
C      call T89D_DP (iopt,parmod,ps,x,y,z,bx,by,bz)
C      print *, bx,by,bz
C      goto 1
C      end
C      SUBROUTINE faker()
C        PRINT*, 'SMALL FAKE'
C      RETURN
C      END

C=======================================================================
C
      SUBROUTINE T89D_DP (IOPT,PARMOD,PS,X,Y,Z,BX,BY,BZ)
C          (double precision version)
C
C   COMPUTES GSM COMPONENTS OF THE MAGNETIC FIELD PRODUCED BY EXTRA-
C   TERRESTRIAL CURRENT SYSTEMS IN THE GEOMAGNETOSPHERE. THE MODEL IS
C   VALID UP TO GEOCENTRIC DISTANCES OF 70 RE AND IS BASED ON THE MER-
C   GED IMP-A,C,D,E,F,G,H,I,J (1966-1974), HEOS-1 AND -2 (1969-1974),
C   AND ISEE-1 AND -2  SPACECRAFT DATA SET.
C
c   NOTE OF NOV 12, 2014:
C
C   THIS IS THIRD UPGRADE OF THE OLD T89 MODEL, IN WHICH ALL COEFFICIENTS
C    (HENCE, THE MODEL OUTPUT) REMAINED IDENTICAL TO THOSE OF T89C.
C   ALL MODIFICATIONS WERE MADE WITH RESPECT TO THE CODE STRUCTURE, WHICH
C    MADE IT POSSIBLE TO SIGNIFICANTLY BOOST THE SPEED.
C--------------------------------------------------------------------------
C -----------   OLD COMMENTS OF 1992:  ------------------------------------
C
C   THIS IS A MODIFIED VERSION (T89c), WHICH REPLACED THE ORIGINAL ONE
C     IN 1992 AND DIFFERS FROM IT IN THE FOLLOWING:
C
C   (1)  ISEE-1,2 DATA WERE ADDED TO THE ORIGINAL IMP-HEOS DATASET
C   (2)  TWO TERMS WERE ADDED TO THE ORIGINAL TAIL FIELD MODES, ALLOWING
C          A MODULATION OF THE CURRENT BY THE GEODIPOLE TILT ANGLE
C
C  REFERENCE FOR THE ORIGINAL MODEL: N.A. TSYGANENKO, A MAGNETOSPHERIC MAGNETIC
C       FIELD MODEL WITH A WARPED TAIL CURRENT SHEET: PLANET.SPACE SCI., V.37,
C         PP.5-20, 1989.
C
C----INPUT PARAMETERS: IOPT - SPECIFIES THE GROUND DISTURBANCE LEVEL:
C
C   IOPT= 1       2        3        4        5        6      7
C                  CORRESPOND TO:
C    KP= 0,0+  1-,1,1+  2-,2,2+  3-,3,3+  4-,4,4+  5-,5,5+  > =6-
C
C    PS - GEODIPOLE TILT ANGLE IN RADIANS
C    X, Y, Z  - GSM COORDINATES OF THE POINT IN EARTH RADII
C
C----OUTPUT PARAMETERS: BX,BY,BZ - GSM COMPONENTS OF THE MODEL MAGNETIC
C                        FIELD IN NANOTESLAS
c
c   THE PARAMETER PARMOD(10) IS A DUMMY ARRAY.  IT IS NOT USED IN THIS
C        SUBROUTINE AND IS PROVIDED JUST FOR MAKING IT COMPATIBLE WITH THE
C           NEW VERSION (4/16/96) OF THE GEOPACK SOFTWARE.
C
C   THIS RELEASE OF T89C/D IS DATED  FEB 12, 1996;   UPDATED APR 29, 2013
C--------------------------------------------------------------------------
C
C
C              AUTHOR:     NIKOLAI A. TSYGANENKO
C                          HSTX CORP./NASA GSFC (1992-2007)
C                          SPB STATE UNIVERSITY (2007-present)
C
      IMPLICIT REAL*8 (A-H,O-Z)
      DIMENSION PARAM(30,7),A(30),PARMOD(10)
      DATA A02,XLW2,YN,RPI,RT/25.D0,170.D0,30.D0,0.31830989D0,30.D0/
      DATA XD,XLD2/0.D0,40.D0/
C
C   The last 2 quantities define variation of tail sheet thickness along X
C
      DATA SXC,XLWC2/4.D0,50.D0/
C
C   The two quantities belong to the function WC which confines tail closure
c    current in X- and Y- direction
C
      DATA DXL/20.D0/

      DATA PARAM/-116.53D0,-10719.D0,42.375D0,59.753D0,-11363.D0,
     * 1.7844D0,30.268D0,-.35372D-01,-0.66832D-01,0.16456D-01,-1.3024D0,
     * 0.16529D-02,0.20293D-02,20.289D0,-0.25203D-01,224.91D0,-9234.8D0,
     * 22.788D0,7.8813D0,1.8362D0,-0.27228D0,8.8184D0,2.8714D0,14.468D0,
     * 32.177D0,0.01D0,0.0D0,7.0459D0,4.0D0,20.0D0,
     * -55.553D0,-13198.D0,
     * 60.647D0,61.072D0,-16064.D0,2.2534D0,34.407D0,-0.38887D-01,
     * -0.94571D-01,0.27154D-01,-1.3901D0,0.13460D-02,0.13238D-02,
     * 23.005D0,-0.30565D-01,55.047D0,-3875.7D0,20.178D0,7.9693D0,
     * 1.4575D0,0.89471D0,9.4039D0,3.5215D0,14.474D0,36.555D0,0.01D0,
     * 0.0D0,7.0787D0,4.0D0,20.D0,
     *-101.34D0,-13480.D0,111.35D0,12.386D0,
     * -24699.D0,2.6459D0,38.948D0,-0.34080D-01,-0.12404D0,0.29702D-01,
     * -1.4052D0,0.12103D-02,0.16381D-02,24.49D0,-0.37705D-01,-298.32D0,
     * 4400.9D0,18.692D0,7.9064D0,1.3047D0,2.4541D0,9.7012D0,7.1624D0,
     * 14.288D0,33.822D0,0.01D0,0.0D0,6.7442D0,4.0D0,20.0D0,
     *-181.69D0,
     * -12320.D0,173.79D0,-96.664D0,-39051.D0,3.2633D0,44.968D0,
     * -0.46377D-01,-0.16686D0,0.048298D0,-1.5473D0,0.10277D-02,
     * 0.31632D-02,27.341D0,-0.50655D-01,-514.10D0,12482.D0,16.257D0,
     * 8.5834D0,1.0194D0,3.6148D0,8.6042D0,5.5057D0,13.778D0,32.373D0,
     * 0.01D0,0.0D0,7.3195D0,4.0D0,20.0D0,
     *-436.54D0,-9001.0D0,323.66D0,
     * -410.08D0,-50340.D0,3.9932D0,58.524D0,-0.38519D-01,-0.26822D0,
     * 0.74528D-01,-1.4268D0,-0.10985D-02,0.96613D-02,27.557D0,
     * -0.56522D-01,-867.03D0,20652.D0,14.101D0,8.3501D0,0.72996D0,
     * 3.8149D0,9.2908D0,6.4674D0,13.729D0,28.353D0,0.01D0,0.0D0,
     * 7.4237D0,4.0D0,20.0D0,-707.77D0,-4471.9D0,432.81D0,-435.51D0,
     * -60400.D0,4.6229D0,68.178D0,-0.88245D-01,-0.21002D0,0.11846D0,
     * -2.6711D0,0.22305D-02,.10910D-01,27.547D0,-0.54080D-01,-424.23D0,
     * 1100.2D0,13.954D0,7.5337D0,0.89714D0,3.7813D0,8.2945D0,5.174D0,
     * 14.213D0,25.237D0,0.01D0,0.0D0,7.0037D0,4.0D0,20.0D0,-1190.4D0,
     * 2749.9D0,742.56D0,-1110.3D0,-77193.D0,7.6727D0,102.05D0,
     *-0.96015D-01,-0.74507,0.11214,-1.3614,0.15157D-02,0.22283D-01,
     *23.164,-0.74146D-01,-2219.1D0,48253.D0,12.714D0,7.6777D0,.57138D0,
     * 2.9633D0,9.3909D0,9.7263D0,11.123D0,21.558D0,0.01D0,0.0D0,
     * 4.4518D0,4.0D0,20.0D0/

       DATA IOP/10/

       SAVE
C
       IF (IOP.NE.IOPT) THEN
C
       IOP=IOPT
       DO 1 I=1,30
   1   A(I)=PARAM(I,IOPT)
C
       DYC=A(30)
       DYC2=DYC**2
       DX=A(18)
       HA02=0.5D0*A02
       RDX2M=-1.D0/DX**2
       RDX2=-RDX2M
       RDYC2=1.D0/DYC2
       HLWC2M=-0.5D0*XLWC2
       DRDYC2=-2.D0*RDYC2
       DRDYC3=2.D0*RDYC2*DSQRT(RDYC2)
       HXLW2M=-0.5D0*XLW2
       ADR=A(19)
       D0=A(20)
       DD=A(21)
       RC=A(22)
       G=A(23)
       AT=A(24)
       DT=D0
       DEL=A(26)
       P=A(25)
       Q=A(27)
       SX=A(28)
       GAM=A(29)
       HXLD2M=-0.5D0*XLD2
       ADSL=0.D0
       XGHS=0.D0
       H=0.D0
       HS=0.D0
       GAMH=0.D0
       W1=-0.5D0/DX
       DBLDEL=2.D0*DEL
       W2=W1*2.D0
       W4=-1.D0/3.D0
       W3=W4/DX
       W5=-0.5D0
       W6=-3.D0
       AK1=A(1)
       AK2=A(2)
       AK3=A(3)
       AK4=A(4)
       AK5=A(5)
       AK6=A(6)
       AK7=A(7)
       AK8=A(8)
       AK9=A(9)
       AK10=A(10)
       AK11=A(11)
       AK12=A(12)
       AK13=A(13)
       AK14=A(14)
       AK15=A(15)
       AK16=A(16)
       AK17=A(17)
       SXA=0.D0
       SYA=0.D0
       SZA=0.D0
       AK610=AK6*W1+AK10*W5
       AK711=AK7*W2-AK11
       AK812=AK8*W2+AK12*W6
       AK913=AK9*W3+AK13*W4
       RDXL=1.D0/DXL
       HRDXL=0.5D0*RDXL
       A6H=AK6*0.5D0
       A9T=AK9/3.D0
       YNP=RPI/YN*0.5D0
       YND=2.D0*YN
C
       ENDIF
C
       SPS = DSIN(PS)
       CPS = DCOS(PS)
C
       X2=X*X
       Y2=Y*Y
       Z2=Z*Z
       TPS=SPS/CPS
       HTP=TPS*0.5D0
       GSP=G*SPS
       XSM=X*CPS-Z*SPS
       ZSM=X*SPS+Z*CPS
C
C   CALCULATE THE FUNCTION ZS DEFINING THE SHAPE OF THE TAIL CURRENT SHEET
C    AND ITS SPATIAL DERIVATIVES:
C
       XRC=XSM+RC
       XRC16=XRC**2+16.D0
       SXRC=DSQRT(XRC16)
       Y4=Y2*Y2
       Y410=Y4+1.D4
       SY4=SPS/Y410
       GSY4=G*SY4
       ZS1=HTP*(XRC-SXRC)
       DZSX=-ZS1/SXRC
       ZS=ZS1-GSY4*Y4
       D2ZSGY=-SY4/Y410*4.D4*Y2*Y
       DZSY=G*D2ZSGY
C
C   CALCULATE THE COMPONENTS OF THE RING CURRENT CONTRIBUTION:
C
       XSM2=XSM**2
       DSQT=DSQRT(XSM2+A02)
       FA0=0.5D0*(1.D0+XSM/DSQT)
       DDR=D0+DD*FA0
       DFA0=HA02/DSQT**3
       ZR=ZSM-ZS
       TR=DSQRT(ZR**2+DDR**2)
       RTR=1.D0/TR
       RO2=XSM2+Y2
       ADRT=ADR+TR
       ADRT2=ADRT**2
       FK=1.D0/(ADRT2+RO2)
       DSFC=DSQRT(FK)
       FC=FK**2*DSFC
       FACXY=3.0D0*ADRT*FC*RTR
       XZR=XSM*ZR
       YZR=Y*ZR
       DBXDP=FACXY*XZR
       DER25=FACXY*YZR
       XZYZ=XSM*DZSX+Y*DZSY
       FAQ=ZR*XZYZ-DDR*DD*DFA0*XSM
       DBZDP=FC*(2.D0*ADRT2-RO2)+FACXY*FAQ
       DER15=DBXDP*CPS+DBZDP*SPS
       DER35=DBZDP*CPS-DBXDP*SPS
C
C  CALCULATE THE TAIL CURRENT SHEET CONTRIBUTION:
C
       DELY2=DEL*Y2
       D=DT+DELY2
       IF (DABS(GAM).LT.1.D-6) GOTO 8
       XXD=XSM-XD
       RQD=1.D0/(XXD**2+XLD2)
       RQDS=DSQRT(RQD)
       H=0.5D0*(1.D0+XXD*RQDS)
       HS=-HXLD2M*RQD*RQDS
       GAMH=GAM*H
       D=D+GAMH
       XGHS=XSM*GAM*HS
       ADSL=-D*XGHS
   8   D2=D**2
       T=DSQRT(ZR**2+D2)
       XSMX=XSM-SX
       RDSQ2=1.D0/(XSMX**2+XLW2)
       RDSQ=DSQRT(RDSQ2)
       V=0.5D0*(1.D0-XSMX*RDSQ)
       DVX=HXLW2M*RDSQ*RDSQ2
       OM=DSQRT(DSQRT(XSM2+16.D0)-XSM)
       OMS=-OM/(OM*OM+XSM)*0.5D0
       RDY=1.D0/(P+Q*OM)
       OMSV=OMS*V
       RDY2=RDY**2
       FY=1.D0/(1.D0+Y2*RDY2)
       W=V*FY
       YFY1=2.D0*FY*Y2*RDY2
       FYPR=YFY1*RDY
       FYDY=FYPR*FY
       DWX=DVX*FY+FYDY*Q*OMSV
       YDWY=-V*YFY1*FY
       DDY=DBLDEL*Y
       ATT=AT+T
       S1=DSQRT(ATT**2+RO2)
       F5=1.D0/S1
       F7=1.D0/(S1+ATT)
       F1=F5*F7
       F3=F5**3
       F9=ATT*F3
       FS=ZR*XZYZ-D*Y*DDY+ADSL
       XDWX=XSM*DWX+YDWY
       RTT=1.D0/T
       WT=W*RTT
       BRRZ1=WT*F1
       BRRZ2=WT*F3
       DBXC1=BRRZ1*XZR
       DBXC2=BRRZ2*XZR

       TLT2=PS**2

       DER21=BRRZ1*YZR
       DER22=BRRZ2*YZR
       DER216=DER21*TLT2
       DER217=DER22*TLT2
       WTFS=WT*FS
       DBZC1=W*F5+XDWX*F7+WTFS*F1
       DBZC2=W*F9+XDWX*F1+WTFS*F3
       DER11=DBXC1*CPS+DBZC1*SPS
       DER12=DBXC2*CPS+DBZC2*SPS
       DER31=DBZC1*CPS-DBXC1*SPS
       DER32=DBZC2*CPS-DBXC2*SPS
       DER116=DER11*TLT2
       DER117=DER12*TLT2
       DER316=DER31*TLT2
       DER317=DER32*TLT2
C
C  CALCULATE CONTRIBUTION FROM THE CLOSURE CURRENTS
C
       ZPL=Z+RT
       ZMN=Z-RT
       ROGSM2=X2+Y2
       SPL=DSQRT(ZPL**2+ROGSM2)
       SMN=DSQRT(ZMN**2+ROGSM2)
       XSXC=X-SXC
       RQC2=1.D0/(XSXC**2+XLWC2)
       RQC=DSQRT(RQC2)
       FYC=1.D0/(1.D0+Y2*RDYC2)
       WC=0.5D0*(1.D0-XSXC*RQC)*FYC
       DWCX=HLWC2M*RQC2*RQC*FYC
       DWCY=DRDYC2*WC*FYC*Y
       SZRP=1.D0/(SPL+ZPL)
       SZRM=1.D0/(SMN-ZMN)
       XYWC=X*DWCX+Y*DWCY
       WCSP=WC/SPL
       WCSM=WC/SMN
       FXYP=WCSP*SZRP
       FXYM=WCSM*SZRM
       FXPL=X*FXYP
       FXMN=-X*FXYM
       FYPL=Y*FXYP
       FYMN=-Y*FXYM
       FZPL=WCSP+XYWC*SZRP
       FZMN=WCSM+XYWC*SZRM
       DER13=FXPL+FXMN
       DER14=(FXPL-FXMN)*SPS
       DER23=FYPL+FYMN
       DER24=(FYPL-FYMN)*SPS
       DER33=FZPL+FZMN
       DER34=(FZPL-FZMN)*SPS
C
C   NOW CALCULATE CONTRIBUTION FROM CHAPMAN-FERRARO SOURCES + ALL OTHER
C
       EX=DEXP(X/DX)
       EC=EX*CPS
       ES=EX*SPS
       ECZ=EC*Z
       ESZ=ES*Z
       ESZY2=ESZ*Y2
       ESZZ2=ESZ*Z2
       ECZ2=ECZ*Z
       ESY=ES*Y
C
C  FINALLY, CALCULATE NET EXTERNAL MAGNETIC FIELD COMPONENTS,
C    BUT FIRST OF ALL THOSE FOR C.-F. FIELD:
C
       SX1=AK6*ECZ+AK7*ES+AK8*ESY*Y+AK9*ESZ*Z
       SY1=AK10*ECZ*Y+AK11*ESY+AK12*ESY*Y2+AK13*ESY*Z2
       SZ1=AK14*EC+AK15*EC*Y2+AK610*ECZ2+AK711*ESZ+AK812
     * *ESZY2+AK913*ESZZ2
       BXCL=AK3*DER13+AK4*DER14
       BYCL=AK3*DER23+AK4*DER24
       BZCL=AK3*DER33+AK4*DER34
       BXT=AK1*DER11+AK2*DER12+BXCL +AK16*DER116+AK17*DER117
       BYT=AK1*DER21+AK2*DER22+BYCL +AK16*DER216+AK17*DER217
       BZT=AK1*DER31+AK2*DER32+BZCL +AK16*DER316+AK17*DER317
       BX=BXT+AK5*DER15+SX1+SXA
       BY=BYT+AK5*DER25+SY1+SYA
       BZ=BZT+AK5*DER35+SZ1+SZA
C
       RETURN
       END
c
c=======================================================================