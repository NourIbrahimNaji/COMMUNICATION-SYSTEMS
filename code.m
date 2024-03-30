Fm = 1;
Fc = 25;
u = 0.25;
Ac =1;
 
tau_min = 1/Fc;              
tau_max = 1/Fm; 

tau = tau_min:0.001:tau_max;   
num_tau=length(tau); 

Ts=tau_min/100;               
t =0: Ts:2*tau_max;           
num_pts=length(t);            
            
Envelope_Signal  =  abs(1 + u*cos(2*pi*Fm*t));   
Modulated_Signal =  Ac*Envelope_Signal.*cos(2*pi*Fc*t); 
message_Signal =cos(2*pi*Fm*t);

axis([0 2 -2 2]);

subplot(3,1,1),  plot(t,message_Signal,'r');
title('message m(t)');
xlabel('time(s)');
ylabel('m(t)');
grid on ;

subplot(3,1,2),  plot(t,Modulated_Signal,'g');
title('normal AM waveform');
xlabel('time(s)');
ylabel('s(t)');
grid on ;

subplot(3,1,3),  plot(t,Envelope_Signal,'b');
title(' demodulated signal');
xlabel('time(s)');
ylabel('yi(t)');
grid on ;


for i=1:num_tau 
    output_signal(1,1)=1+u;

    for n=1:num_pts-1
           if output_signal(1,n) < Modulated_Signal(1,n)
            output_signal(1,n+1)= Modulated_Signal(1,n); 

           else
            output_signal(1,n+1)=output_signal(1,n)*exp(-Ts/tau(1,i));
        end
    end

   error(1,i)=(sum((output_signal-Envelope_Signal).^2))/num_pts;
end

[~,TauOptimum]=min(error); 
 output_signal(1,1)=1+u;
 
 for n=1:num_pts
     if output_signal(1,n)<Modulated_Signal(1,n)
         output_signal(1,n+1)=Modulated_Signal(1,n+1);
     else
        output_signal(1,n+1)=output_signal(1,n)*exp(-Ts/tau(1,TauOptimum));
     end
 end

figure(2);
plot(t,Modulated_Signal);
hold on 
plot(t,output_signal,'g','linewidth',2.0);
hold on 
title(' practical envelope detector and s(t)');

figure(3);
title('practical modulated message from envelope detector');
plot(t,output_signal,'b','linewidth',1.5);

figure(4);
plot(tau, mean_squared_error);
grid on;
xlabel('tau');
ylabel('distortion');
title('distortion');
