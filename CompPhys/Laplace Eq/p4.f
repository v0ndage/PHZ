        program laplaceshort
        real v(40,40),v1(40,40)
        v=0.0
        v1=0.0
        open(7,file="2nd_potential")
  111   format(40(2x,e12.5))
        print*,"Enter number of iterations"
        read(5,*) ni
        do j=10,30
          v(15,j)=-1.0
          v1(15,j)=-1.0
          v(25,j)=1.0
          v1(25,j)=1.0
        enddo
        do ii=1,ni
          call update(v,v1,40)
          do j=10,30
            v1(15,j)=-1.0
            v1(25,j)=1
          enddo
          call update(v1,v,40)
          do j=10,30
            v(15,j)=-1.0
            v(25,j)=1.0
          enddo
          dv=0.0
          do i=2,39
            do j=2,39
              err=abs(v1(i,j)-v(i,j))
              if(err>dv) then
                dv=err
              endif
            enddo
          enddo
          if(dv<1.0e-5) then
            goto 55
          endif
        enddo
  55    continue
        if(dv>1.0e-5) then
          print*, "Potential has not converged"
          print*, dv
        endif
        do j=1,40
          write(7,111) (v(i,j),i=1,40)
        enddo
        end

        subroutine update(v,v1,n)
        real v(n,n),v1(n,n)
        do i=2,n-1
          do j=2,n-1
            v1(i,j)=0.25*(v(i+1,j)+v(i-1,j)+v(i,j+1)+v(i,j-1))
          enddo
        enddo
        return
        end
