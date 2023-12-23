
%Everything is in SI units past this point
%Variable Definitions
%y a vector of is the Force in Newtons, x is the time over which the
%varying forces occur
%Aft = 19.24 lb
%Mid = 5.59 lb
%Forward  = 18.012 lb
%% Data Used in Accounting for Thrust and Propellant Burn
motorBurn = burn();
y=thrust();
x=tim();
m=cat(1,motorBurn,0)./1000; %from g to kg

%Effective Cross Sectional Area of Rocket
A=0.0080825645;
%Total Mass of Rocket
weight = 19.43;
%Duration of Flight
dur=2.9;
%air density
ro=1.225;
%total mass lost during flight
propWeight=1.973;
%acceleration due to gravity
g=9.81;
%Drag coefficient
C_d=0.6;

%Equations used:
%Mass lost over time (function n) *assumption, loss of mass over time due
%to propellant burn can be approximated to be linear
%m(t)=weight - (propWeight/dur)*t
%Force over time:
%f(t) (is found using the best fit line tool and saving it to workspace)
%drag force:
%F_d = 1/2(ro)(v^2)(A)(C_d)
%Force due to gravity:
%F_g=m(t)*g


%% Approximating Altitude and Velocity over Time
%terminal velocity = 4.35
%using ode45 to solve the diffeq
%setting up inital conditions and time vectors to use,
x0=[0,0];
tspan = [0 2.6];
tspan2 = [max(x) 30];
tspan3 = [30 51.9];
tspan4 = [51.91 90.7];
%running ode 45 with various conditions based on state of rocket
[t,x1] = ode45(@position01, x,x0 );
[t2, x2] = ode45(@position2 , tspan2, [x1(length(x1),1),x1(length(x1),2)]);
[t3, x3] = ode45(@position3 , tspan3, [x2(length(x2),1),x2(length(x2),2)]);
[t4, x4] = ode45(@position4 , tspan4, [x3(length(x3),1),x3(length(x3),2)]);
xFinal = cat(1,x1,x2,x3,x4);
tFinal = cat(1,t,t2,t3,t4);
%% Plotting Results

figure;
plot(x,y)
title('Thrust of rocket over time')
xlabel('time (seconds)')
ylabel('Force (Newtons)')

figure;
plot(x,m)
title('Mass of rocket propellant over time')
xlabel('time (seconds)')
ylabel('Mass (kg)')
[Apogee, apogeeIndex] = max(xFinal(:,1));
timeOfApogee = tFinal(apogeeIndex);
figure;
subplot(2,1,1);
plot(tFinal, xFinal(:,1));
xlabel('Time')
ylabel('Position (m)')
title("Position and Velocity over Time (Apogee = "+ floor(Apogee) + "m at t = " +...
    round(timeOfApogee, 2) + "sec )" );
subplot(2,1,2);
plot(tFinal, xFinal(:,2));
xlabel('Time')
ylabel('Velocity (m/s^2)')
%%
%Finding a best fit line
%-444.673048066401*t^10+7861.29244373069*t^9-58789.4063118116*t^8+243586.233686891*t^7
%-614071.424962456*t^6+971874.732925931*t^5-959370.713362109*t^4+
% 565467.299797210*t^3-180670.046352333*t^2+25942.5542978860*t+276.319003851257
%used basic fit data tool, very lengthy, and needs to be recalculated after
%finding net force and divided by m(t)

%lline is the equation put into string form
lline = "";
coe = [-444.673048066401,7861.29244373069,...
    -58789.4063118116,243586.233686891,-614071.424962456,971874.732925931,...
    -959370.713362109,565467.299797210,-180670.046352333,25942.5542978860...
    ,276.319003851257];
for i=0:10
    v=10-i;
    lline = lline + coe(i+1)+"t^"+v+"+ ";
    
end
%% Function Definitions
function dxdt = position01(t,x)
A=0.0080825645;
weight = 19.54983;
coe = [-444.673048066401,7861.29244373069,...
    -58789.4063118116,243586.233686891,-614071.424962456,971874.732925931,...
    -959370.713362109,565467.299797210,-180670.046352333,25942.5542978860,...
    276.319003851257];
dur=2.6;
ro=1.225;
propWeight=1.973;
g=9.81;
C_d=0.6;
c_1=1/2*ro*A*C_d;
dxdt = [x(2);-g+(coe(1)*t^10+coe(2)*t^9+coe(3)*t^8+coe(4)*t^7+ ...
    coe(5)*t^6+coe(6)*t^5+coe(7)*t^4+coe(8)*t^3+coe(9)*t^2+coe(10)*t ...
    +coe(11)-c_1*(x(2)^2))/(weight-propWeight/dur)];
end

function dxdt = position2(t,x)
A=0.0080825645;
weight = 19.54983;
ro=1.225;
propWeight=1.973;
g=9.81;
C_d=0.6;
c_1=1/2*ro*A*C_d;
dxdt = [x(2);-g+((-c_1*(x(2)^2))/(weight-propWeight))];
end

function dxdt = position3(t,x)
A=0.0080825645;
weight = 19.54983;
ro=1.225;
propWeight=1.973;
g=9.81;
C_d=0.6;
c_1=1/2*ro*A*C_d; 


dxdt = [x(2);-g+((c_1*(x(2)^2)+1.5*x(2)^2*ro*0.5*0.16417322322...
)/(weight-propWeight))];
end

function dxdt = position4(t,x)
A=0.0080825645;
weight = 19.54983;
ro=1.225;
propWeight=1.973;
g=9.81;
C_d=0.6;
c_1=1/2*ro*A*C_d;
aftMass = 8.7271172;
c_3 = 1.5*ro*0.5*0.16417322322;
c_4 = 0.5*2.2*ro*7.296587699;

dxdt = [x(2);-g+x(2)^2*((c_1)/(weight-propWeight)+(c_3)/(8.7271172)...
+(c_4)/(weight-propWeight-aftMass))];
end

%% Data Used in Accounting for Thrust and Propellant Burn
function f = thrust()
f=[0
906.203000000000
1249.41000000000
1336.72000000000
1369.84000000000
1402.96000000000
1411.99000000000
1411.99000000000
1586.61000000000
1649.83000000000
1640.80000000000
1625.74000000000
1628.76000000000
1619.72000000000
1607.68000000000
1601.66000000000
1589.62000000000
1550.48000000000
1499.30000000000
1424.03000000000
1366.83000000000
1312.64000000000
1261.46000000000
1228.34000000000
1213.29000000000
1204.26000000000
1198.23000000000
1198.23000000000
1165.12000000000
1074.80000000000
957.383000000000
839.968000000000
713.522000000000
590.085000000000
427.511000000000
295.043000000000
153.543000000000
69.2450000000000
0];
end
function g = tim()
g=[0
0.0180000000000000
0.0410000000000000
0.0550000000000000
0.0990000000000000
0.173000000000000
0.236000000000000
0.284000000000000
0.678000000000000
0.869000000000000
0.939000000000000
1.10200000000000
1.19700000000000
1.29300000000000
1.37400000000000
1.45500000000000
1.51800000000000
1.59200000000000
1.69100000000000
1.83800000000000
1.96000000000000
2.10000000000000
2.22500000000000
2.34300000000000
2.41700000000000
2.47900000000000
2.52400000000000
2.56400000000000
2.60100000000000
2.63800000000000
2.66000000000000
2.68900000000000
2.71200000000000
2.73700000000000
2.76300000000000
2.80000000000000
2.84400000000000
2.87700000000000
2.91100000000000];
end
function w = burn()
w= [1973.
1968.92
1956.53
1947.48
1917.71
1866.42
1822.09
1788.21
1492.88
1338.36
1280.78
1147.68
1070.4
992.446
927.099
862.118
811.861
753.777
678.304
570.885
485.774
392.004
311.573
238.133
192.968
155.501
128.476
104.514
82.6561
61.9394
50.7637
37.7345
28.8031
20.6565
14.0429
7.36013
2.42629
0.];
end
