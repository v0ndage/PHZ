        program pendulum
        real omega(300),teta(300),t(300)
        open(7,file="pen-r-d_out")
  100   format(2(2x,e12.5))
        print*, "Enter teta0"
        read(5,*) teta0
        print*, "Enter q" !resistance coefficient
        read(5,*) q
        print*, "Enter fr-multipl."
        read(5,*) frdf
        pi=3.1415927
        teta0=teta0*pi/180.0
        l=1.0
        g=9.8
        df=0.2
        freq=sqrt(g/l)
        frdr=frdf*freq
        period=2.0*pi/freq
        tt=4.0*period
        dt=tt/300
        omega(1)=0.0
        teta(1)=teta0
        gl=g/l
        t(1)=0.0
        do i=1,299
          t(i+1)=t(i)+dt
          omega(i+1)=omega(i)-(gl*teta(i)+q*omega(i)
     *    -df*cos(frdr*t(i+1)))*dt
          teta(i+1)=teta(i)+omega(i+1)*dt
          write(7,100) teta(i+1),omega(i+1)
        enddo
        close(7)
        end
