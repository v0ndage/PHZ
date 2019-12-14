        program montecarlo
        real sm(10,10)
        real esm(10,10)
        dt=0.03
        print*, "Enter itmp"
        ! read(5,*) itmp
        open(7,file="mag-temp")
  110   format(3(2x,e12.5)) !Temp/Mag/Energy
        open(8,file="Mag-Temp")
        smtot=0.0
        do i=1,10
          do j=1,10
            r1=rand(0)
            sm(i,j)=1.0
            if (r1<0.5) then
              sm(i,j)=-1.0
            endif
            smtot=smtot+sm(i,j)
          enddo
        enddo
        print*,smtot
        do itmp=1,200 ! Temperature
        temp=itmp*dt
        smav=0.0
        do its=1,1000 ! timesteps
          smtot=0.0
          etot=0.0
          do i=2,9
            do j=2,9
              sm4=sm(i,j-1)+sm(i,j+1)+sm(i-1,j)+sm(i+1,j)
              esm(i,j)=-sm(i,j)*sm4
              call flip(sm(i,j),esm(i,j),temp)
              smtot=smtot+sm(i,j)
              etot=etot+esm(i,j)
            enddo
          enddo
          
          sm11=sm(1,2)+sm(2,1)+sm(1,10)+sm(10,1)
          esm(1,1)=-sm(1,1)*sm11
          call flip(sm(1,1),esm(1,1),temp)
          smtot=smtot+sm(1,1)
          etot=etot+esm(1,1)

          sm101=sm(1,1)+sm(9,1)+sm(10,10)+sm(10,2)
          esm(10,1)=-sm(10,1)*sm101
          call flip(sm(10,1),esm(10,1),temp)
          smtot=smtot+sm(10,1)
          etot=etot+esm(10,1)

          sm110=sm(1,9)+sm(2,10)+sm(1,1)+sm(10,10)
          esm(1,10)=-sm(1,10)*sm110
          call flip(sm(1,10),esm(1,10),temp)
          smtot=smtot+sm(1,10)
          etot=etot+esm(1,10)

          sm1010=sm(10,9)+sm(9,10)+sm(1,10)+sm(10,1)
          esm(10,10)=-sm(10,10)*sm1010
          call flip(sm(10,10),esm(10,10),temp)
          smtot=smtot+sm(10,10)
          etot=etot+esm(10,10)

          do j=2,9
            sm1j=sm(1,j-1)+sm(2,j)+sm(1,j+1)+sm(10,j)
            esm(1,j)=-sm(1,j)*sm1j
            call flip(sm(1,j),esm(1,j),temp)
            smtot=smtot+sm(1,j)
            etot=etot+esm(1,j)

            sm10j=sm(10,j-1)+sm(9,j)+sm(10,j+1)+sm(1,j)
            esm(10,j)=-sm(10,j)*sm10j
            call flip(sm(10,j),esm(10,j),temp)
            smtot=smtot+sm(10,j)
            etot=etot+esm(10,j)
          enddo

          do i=2,9
            sm1i=sm(i-1,1)+sm(i,2)+sm(i+1,1)+sm(i,10)
            esm(i,1)=-sm(i,1)*sm1i
            call flip(sm(i,1),esm(i,1),temp)
            smtot=smtot+sm(i,1)
            etot=etot+esm(i,1)

            sm10i=sm(i-1,10)+sm(i,9)+sm(i+1,10)+sm(i,1)
            esm(i,10)=-sm(i,10)*sm10i
            call flip(sm(i,10),esm(i,10),temp)
            smtot=smtot+sm(i,10)
            etot=etot+esm(i,10)
          enddo
          smav=smav+smtot
          esmav=esmav+etot
          ! write(7,110) 1.0*its,smtot 
        enddo ! timesteps
        smav=smav*0.001
        esmav=esmav*0.001
        write(8,110) temp,smav,esmav
        enddo ! Temp
        end

        subroutine flip(smf,esmf,temp)
        esm1=-esmf
        if(esm1<esmf) then
          smf=-smf !flip
          esmf=esm1
        else
          bf=exp(-2.0*esm1/temp)
          r1=rand(0)
          if(r1<bf) then
            smf=-smf
            emsf=esm1
          endif
        endif
        return
        end
