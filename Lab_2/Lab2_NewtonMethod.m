clc
clear
% SCRIPT TO CREATE A DEMO FOR NEWTON'S METHOD
% Use this as JUST a guide and feel free to write as you wish


% create a function poly.m and write desired equation and return
% independent variable
f = @poly;     

% create a function poly_derivative.m and write desired equation and return
% independent variable
fder = @poly_derivative;

maxIters =  100;
tol = 1e-06;

% experiment with different values of xi
xi = 10.0;

% Initialization of relative errors, rel_errs
rel_errs = zeros(maxIters,1);
xr=xi;

% caluculate function values for each value of xlim_values using for loop
f_values=[];
xlim_values=[-abs(xr):0.1:abs(xr)];
% write from here
f_values=f(xlim_values);


% plot the xlim_values vs function values and draw x-axis and y-axis
% centered at origin
% write your code here
figure()
plot(xlim_values,f_values,'k');
xlim([-10 10])
ylim([-200 200])
set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin')


% write xr as 'x0' to denote initial point. Use text function to write text on figures
% write from here
text(xr,0,'x0')
p = [xr xr];
q = [0 f(xr)];
line(p,q,'Color','red')


% plot tangent at xr
% write from here
hold on

k = fder(xr);
b = f(xr)-k*xr;
tangent = k*xlim_values+b;
plot(xlim_values,tangent);
%xi = -b/k;


% draw line from xr to f(xr). Use functions text and line
[xr] = newtons_update(f,fder, xi);
% write from here
p = [xr xr];
q = [0 f(xr)];
line(p,q,'Color','red')
text(xr,0,'x1')


% find Newtons update and write on the same plot
% write from here


% M is the variable to hold frames of video. Use getframe function
%M=[];
count=1;
% write command here and store in M[count]
M(count) = getframe();
hold off
count=count+1;
%pause

%%
for iter = 1:maxIters
    xrold=xr;
    % find Newtons update
    [xr] = newtons_update(f,fder, xrold);
    
    % Relative error from xr and xrold and stopping criteria and break if
    % rel_err<tol. 
    % write from here
    rel_err = abs(xr-xrold);
    if rel_err<tol
        break
    end

    
    
    % plot the xlim_values vs function values and draw x-axis and y-axis
    % centered at origin
    % write from here
    plot(xlim_values,f_values,'k');
    xlim([-10 10])
    ylim([-200 200])
    set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin')

    
    % plot tangent at xr
    % write from here
    hold on
    k = fder(xr);
    b = f(xr)-k*xr;
    tangent = k*xlim_values+b;
    plot(xlim_values,tangent);

    % write xr as xiter_no. ex: x1, x2 for first and second iteration
    % write from here
    text(xr,0,['x',num2str(iter+1)]);

    % draw line from xr to f(xr)
    % write from here
    p = [xr xr];
    q = [0 f(xr)];
    line(p,q,'Color','red')


    % find Newtons update and write on the same plot
    % write from here
    
    
    hold off
    % save the current frame for the video. Store in M(count)
    % write from here
    M(count) = getframe();
    
    
    count=count+1;
    %pause
 
end
  root = xr; % root found by your algorithm

 
%  play movie using movie commnad. 
% write from here
movie(M,1,1)


