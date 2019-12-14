C***************************************************
C This program calculates the solution u of the
C Laplace equation in the unit circle or square
C with Dirichlet boundary conditions using the BEM.    
C***************************************************
      IMPLICIT REAL*8 (A-H,O-Z)
      PARAMETER (M=20)
      DIMENSION X(0:M),Y(0:M),Z1(M),Z2(M)
      DIMENSION A(M,M),B(M,M),U(M),DU(M)
C---------------------------------------------------------
      OPEN(UNIT=10,FILE='result.dat')
C---------------------------------------------------------
C Write the coordinates of the endpoints of the
C elements, i.e. the discretisation of the boundary
C of the body under investigation (unit circle or square).
C---------------------------------------------------------
      PI=4.0D0*DATAN(1.0D0)
C---------------------------------------------------------
      WRITE(10,*) 'circle'
      DO I=0,M
         TETA=2.0D0*PI*DFLOAT(I)/DFLOAT(M)
         X(I)=DCOS(TETA)
         Y(I)=DSIN(TETA)
      ENDDO
C---------------------------------------------------------
C      WRITE(10,*) 'square'
C      DO I=0,(M/4)
C        X(I)=DFLOAT(I)/DFLOAT(M/4)
C        Y(I)=0.0D0
C      ENDDO
C      DO I=(M/4+1),(M/2)
C        X(I)=1.0D0
C        Y(I)=DFLOAT(I-M/4)/DFLOAT(M/4)
C      ENDDO
C      DO I=(M/2+1),(3*M/4)
C        X(I)=1.0D0-DFLOAT(I-M/2)/DFLOAT(M/4)
C        Y(I)=1.0D0
C      ENDDO
C      DO I=(3*M/4+1),M
C        X(I)=0.0D0
C        Y(I)=1.0D0-DFLOAT(I-3*M/4)/DFLOAT(M/4)
C      ENDDO
C---------------------------------------------------------
C Write the nodes, i.e. the coordinates of the midpoint
C of each element
C---------------------------------------------------------
      DO I=1,M
        Z1(I)=(X(I)+X(I-1))/2.0D0
        Z2(I)=(Y(I)+Y(I-1))/2.0D0
      ENDDO
C---------------------------------------------------------
C Write the matrices A and B used in the BEM
C---------------------------------------------------------
      DO I=1,M
       DO J=1,M
        H=DSQRT((X(J-1)-X(J))**2+(Y(J-1)-Y(J))**2)
        A0=DSQRT((X(J-1)-Z1(I))**2+(Y(J-1)-Z2(I))**2)
        B0=DSQRT((X(J)-Z1(I))**2+(Y(J)-Z2(I))**2)
        CB=(A0*A0+H*H-B0*B0)/(2.0D0*H*A0)
        SB=DSIN(DAC(CB))
        CZ=(A0*A0+B0*B0-H*H)/(2.0D0*A0*B0)
        PSI=DAC(CZ)  
        IF(I.EQ.J) THEN
          B(I,J)=-0.50D0
          A(I,J)=(H-H*DLOG(H/2.0D0))/(2.0D0*PI)
        ELSE
          B(I,J)=PSI/(2.0D0*PI)
          A(I,J)=(-A0*CB*DLOG(A0/B0)+H-H*DLOG(B0)-A0*SB*PSI)/(2.0D0*PI)
        ENDIF
       ENDDO
      ENDDO

C---------------------------------------------------------
C Write the boundary condition
C---------------------------------------------------------
      DO I=1,M
        U(I)=SOL(Z1(I),Z2(I))
      ENDDO
C---------------------------------------------------------
C Calculate the RHS of the system
C---------------------------------------------------------
      DO I=1,M
        S=0.0D0
        DO  J=1,M
          S=S-B(I,J)*U(J)
        ENDDO
        DU(I)=S
      ENDDO
C---------------------------------------------------------
C Solve the system of linear equations A*Du=b
C Du is put in b, of generic for Xu=l
C---------------------------------------------------------
      CALL GAUSS(M,A,DU)
C---------------------------------------------------------
C Write the solution u at the point (xo,yo)
C---------------------------------------------------------
      X0=0.50D0
      Y0=0.50D0
      CALL RES(M,X,Y,U,DU,X0,Y0,U0)
      WRITE(10,*) X0,Y0,U0,SOL(X0,Y0)

C---------------------------------------------------------
      STOP
      END                                
C==========================================================



C---------------------------------------------------------
C Subroutine GAUSS solves a linear system of algebraic
C equations using a Gaussian elimination method                              
C-----------------------------------------  
      SUBROUTINE GAUSS(N,A,BB)                                          
      IMPLICIT REAL*8 (A-H,O-Z)                                         
      PARAMETER (EPS=1.0D-10)                                           
      DIMENSION A(N,N),BB(N)
                                            
      NM1=N-1                                                           
      DO K=1,NM1                                                     
       D=0.0D0                                                           
       DO I=K,N                                                        
         IF(DABS(A(I,K)).GT.DABS(D)) THEN                                  
           D=A(I,K)                                                          
           I0=I                                                              
         END IF                                                            
       ENDDO                                                      

       IF(DABS(D).LT.EPS) THEN                                           
         WRITE(10,*) 'SINGULAR MATRIX, COLUM K=',K                         
         STOP 'GAUSS'                                                      
       ELSE IF(I0.NE.K) THEN                                             
         DO J=K,N                                                        
           T=A(K,J)                                                          
           A(K,J)=A(I0,J)                                                    
           A(I0,J)=T                                                         
         ENDDO
         T=BB(K)                                                           
         BB(K)=BB(I0)                                                      
         BB(I0)=T     
       END IF    
       KP1=K+1                                                           
       BB(K)=BB(K)/D                                                     
       DO J=KP1,N                                                     
         A(K,J)=A(K,J)/D                                                   
         DO I=KP1,N                                                     
           A(I,J)=A(I,J)-A(I,K)*A(K,J)                                       
         ENDDO
         BB(J)=BB(J)-A(J,K)*BB(K)                                          
       ENDDO
      ENDDO
      BB(N)=BB(N)/A(N,N)                                                

      DO K=1,NM1                                                     
        I=N-K                                                             
        D=0.0D0                                                           
        IP1=I+1                                                           
        DO J=IP1,N                                                     
          D=D+A(I,J)*BB(J)                                                  
        ENDDO
        BB(I)=BB(I)-D                                                     
      ENDDO

      RETURN                                                            
      END                                                               
C---------------------------------------------------------
C Function DAC just calculate arccos
C---------------------------------------------------------                                       
      FUNCTION DAC(X)                                                   
      IMPLICIT REAL*8 (A-H,O-Z)                                         
      PI=4.0D0*DATAN(1.0D0)                                
        IF(X.GE.1.0D0) THEN                                               
          DAC=0.0D0                                                         
        ELSE IF(X.LE.-1.0D0) THEN                                         
          DAC=PI                                                            
        ELSE                                                              
          DAC=DACOS(X)                                                      
        ENDIF                                                             
      RETURN                                                            
      END                                                               
C---------------------------------------------------------
C Function SOL gives the analytical solution
C---------------------------------------------------------
      FUNCTION SOL(X,Y)
      IMPLICIT REAL*8 (A-H,O-Z)

      SOL=X*Y

      RETURN
      END
C---------------------------------------------------------
C Subroutine RES gives the solution in the
C domain when using BEM
C---------------------------------------------------------          
      SUBROUTINE RES(M,X,Y,U,DU,X0,Y0,U0)                              
      IMPLICIT REAL*8 (A-H,O-Z)
      DIMENSION X(0:M),Y(0:M),U(M),DU(M)

      PI=4.0D0*DATAN(1.0D0)
      S=0.0D0                                                            
      DO  J=1,M
        H=DSQRT((X(J-1)-X(J))**2+(Y(J-1)-Y(J))**2)                            
        A0=DSQRT((X(J-1)-X0)**2+(Y(J-1)-Y0)**2)                    
        B0=DSQRT((X(J)-X0)**2+(Y(J)-Y0)**2)                        
        CB=(A0*A0+H*H-B0*B0)/(2.0D0*A0*H)                                 
        SB=DSIN(DAC(CB))                                    
        CZ=(A0*A0+B0*B0-H*H)/(2.0D0*A0*B0)
        PSI=DAC(CZ)                          
        A=(-A0*CB*DLOG(A0/B0)+H-H*DLOG(B0)-A0*PSI*SB)/(2.0D0*PI)
        B=PSI/(2.0D0*PI)                                               
        S=S+A*DU(J)+B*U(J)                                                
      ENDDO                                                 
      U0=S                                             
      RETURN                                                            
      END                                                    
C---------------------------------------------------------
