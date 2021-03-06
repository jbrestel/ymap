function [p1_a,p1_b,p1_c, p2_a,p2_b,p2_c, p3_a,p3_b,p3_c, p4_a,p4_b,p4_c, p5_a,p5_b,p5_c, p6_a,p6_b,p6_c, p7_a,p7_b,p7_c, skew_factor] = fit_Gaussian_model_hexasomy_2(data,locations,init_width,fraction,skew_factor,func_type,show)
% attempt to fit a single-gaussian model to data.
%[G1_a, G1_b, G1_c, G2_a, G2_b, G2_c, S_a, S_c] = GaussianModel_G1SG2(tet_control,parameter,'fcs1','');
	p1_a = nan;   p1_b = nan;   p1_c = nan;
	p2_a = nan;   p2_b = nan;   p2_c = nan;
	p3_a = nan;   p3_b = nan;   p3_c = nan;
	p4_a = nan;   p4_b = nan;   p4_c = nan;
	p5_a = nan;   p5_b = nan;   p5_c = nan;
	p6_a = nan;   p6_b = nan;   p6_c = nan;
	p7_a = nan;   p7_b = nan;   p7_c = nan;
    
	if isnan(data)
		% fitting variables
		return
	end

	% find max height in data.
	datamax = max(data);
    
	% if maxdata is final bin, then find next highest p
	if (find(data == datamax) == length(data))
		data(data == datamax) = 0;
		datamax = data;
		datamax(data ~= max(datamax)) = [];
	end;
    
	% a = height; b = location; c = width.
	p1_ai = datamax;   p1_bi = locations(1);   p1_ci = init_width;
	p2_ai = datamax;   p2_bi = locations(2);   p2_ci = init_width;
	p3_ai = datamax;   p3_bi = locations(3);   p3_ci = init_width;
	p4_ai = datamax;   p4_bi = locations(3);   p4_ci = init_width;
	p5_ai = datamax;   p5_bi = locations(3);   p5_ci = init_width;
	p6_ai = datamax;   p6_bi = locations(3);   p6_ci = init_width;
	p7_ai = datamax;   p7_bi = locations(3);   p7_ci = init_width;
   
	initial = [p1_ai,p1_ci,  p2_ai,  p3_ai,  p4_ai,  p5_ai,  p6_ai,  p7_ai,  skew_factor];
	options = optimset('Display','off','FunValCheck','on','MaxFunEvals',100000);
	time    = 1:length(data);

	if (data == zeros(1,length(data)))  % curve fittings don't work with no data, curves instead are flat.
		p1_a = 1;
		p1_b = locations(1);
		p1_c = 5;
		p2_a = 1;
		p2_b = locations(2);
		p2_c = p2_a/p1_a*p1_c;             % peak width scales with peak height.
		p3_a = 1;
		p3_b = locations(3);
		p3_c = p3_a/p1_a*p1_c;             % peak width scales with peak height.
		p4_a = 1;
		p4_b = locations(4);
		p4_c = p4_a/p1_a*p1_c;             % peak width scales with peak height.
		p5_a = 1;
		p5_b = locations(5);
		p5_c = p5_a/p1_a*p1_c;             % peak width scales with peak height.
		p6_a = 1;
		p6_b = locations(6);
		p6_c = p6_a/p1_a*p1_c;             % peak width scales with peak height.
		p7_a = 1;
		p7_b = locations(7);
		p7_c = p7_a/p1_a*p1_c;             % peak width scales with peak height.
		skew_factor = 1;
	else
		[Estimates,~,exitflag] = fminsearch(@fiterror, ...   % function to be fitted.
		                                    initial, ...     % initial values.
		                                    options, ...     % options for fitting algorithm.
		                                    time, ...        % problem-specific parameter 1.
		                                    data, ...        % problem-specific parameter 2.
		                                    func_type, ...   % problem-specific parameter 3.
		                                    locations, ...   % problem-specific parameter 4.
		                                    show, ...        % problem-specific parameter 5.
		                                    fraction ...     % problem-specific parameter 6.
		                            );
		if (exitflag > 0)
			% > 0 : converged to a solution.
		else
			% = 0 : exceeded maximum iterations allowed.
			% < 0 : did not converge to a solution.
			% return last best estimate anyhow.
		end;
		p1_a = abs(Estimates(1));
		p1_b = locations(1);
		p1_c = abs(Estimates(2));
		if (p1_c < 2);   p1_c = 2;   end;
		p2_a = abs(Estimates(3));
		p2_b = locations(2);
		p2_c = p2_a/p1_a*p1_c;             % peak width scales with peak height.
		p3_a = abs(Estimates(4));
		p3_b = locations(3);
		p3_c = p3_a/p1_a*p1_c;             % peak width scales with peak height.
		p4_a = abs(Estimates(5));
		p4_b = locations(4);
		p4_c = p4_a/p1_a*p1_c;             % peak width scales with peak height.
		p5_a = abs(Estimates(6));
		p5_b = locations(5);
		p5_c = p5_a/p1_a*p1_c;             % peak width scales with peak height.
		p6_a = abs(Estimates(7));
		p6_b = locations(6);
		p6_c = p6_a/p1_a*p1_c;             % peak width scales with peak height.
		p7_a = abs(Estimates(8));
		p7_b = locations(7);
		p7_c = p7_a/p1_a*p1_c;             % peak width scales with peak height.
		skew_factor = abs(Estimates(9));
	end;
	c1_  = p1_c/2 + p1_c*skew_factor/(100-abs(100-p1_b))/2;
	p1_c = p1_c*p1_c/c1_;
	c2_  = p2_c/2 + p2_c*skew_factor/(100-abs(100-p2_b))/2;
	p2_c = p2_c*p2_c/c2_;        
	c4_  = p4_c/2 + p4_c*skew_factor/(100-abs(100-p4_b))/2;
	p4_c = p4_c*p4_c/c4_;
	c5_  = p5_c/2 + p5_c*skew_factor/(100-abs(100-p5_b))/2;
	p5_c = p5_c*p5_c/c5_;
	c6_  = p6_c/2 + p6_c*skew_factor/(100-abs(100-p6_b))/2;
	p6_c = p6_c*p6_c/c6_;
	c7_  = p7_c/2 + p7_c*skew_factor/(100-abs(100-p7_b))/2;
	p7_c = p7_c*p7_c/c7_;
end

function sse = fiterror(params,time,data,func_type,locations,show,fraction)
	p1_a = abs(params(1));
	p1_b = locations(1);
	p1_c = abs(params(2));
	if (p1_c < 2);   p1_c = 2;   end;
	p2_a = abs(params(3));
	p2_b = locations(2);
	p2_c = p2_a/p1_a*p1_c;             % peak width scales with peak height.
	p3_a = abs(params(4));
	p3_b = locations(3);
	p3_c = p3_a/p1_a*p1_c;             % peak width scales with peak height.
	p4_a = abs(params(5));
	p4_b = locations(4);
	p4_c = p4_a/p1_a*p1_c;             % peak width scales with peak height.
	p5_a = abs(params(6));
	p5_b = locations(5);
	p5_c = p5_a/p1_a*p1_c;             % peak width scales with peak height.
	p6_a = abs(params(7));
	p6_b = locations(6);
	p6_c = p6_a/p1_a*p1_c;             % peak width scales with peak height.
	p7_a = abs(params(8));
	p7_b = locations(7);
	p7_c = p7_a/p1_a*p1_c;             % peak width scales with peak height.
	skew_factor = abs(params(9));
	time1_1 = 1:floor(p1_b);
	time1_2 = ceil(p1_b):200;
	if (time1_1(end) == time1_2(1));    time1_1(end) = [];  end;
	time2_1 = 1:floor(p2_b);
	time2_2 = ceil(p2_b):200;
	if (time2_1(end) == time2_2(1));    time2_1(end) = [];  end;
	time3_1 = 1:floor(p3_b);
	time3_2 = ceil(p3_b):200;
	if (time3_1(end) == time3_2(1));    time3_1(end) = [];  end;
	time5_1 = 1:floor(p5_b);
	time5_2 = ceil(p5_b):200;
	if (time5_1(end) == time5_2(1));    time5_2(1) = [];    end;
	time6_1 = 1:floor(p6_b);
	time6_2 = ceil(p6_b):200;
	if (time6_1(end) == time6_2(1));    time6_2(1) = [];    end;
	time7_1 = 1:floor(p7_b);
	time7_2 = ceil(p7_b):200;
	if (time7_1(end) == time7_2(1));    time7_2(1) = [];    end;
	c1_  = p1_c/2 + p1_c*skew_factor/(100-abs(100-p1_b))/2;
	p1_c = p1_c*p1_c/c1_;
	c2_  = p2_c/2 + p2_c*skew_factor/(100-abs(100-p2_b))/2;
	p2_c = p2_c*p2_c/c2_;        
	c4_  = p4_c/2 + p4_c*skew_factor/(100-abs(100-p4_b))/2;
	p4_c = p4_c*p4_c/c4_;
	c5_  = p5_c/2 + p5_c*skew_factor/(100-abs(100-p5_b))/2;
	p5_c = p5_c*p5_c/c5_;
	c6_  = p6_c/2 + p6_c*skew_factor/(100-abs(100-p6_b))/2;
	p6_c = p6_c*p6_c/c6_;
	c7_  = p7_c/2 + p7_c*skew_factor/(100-abs(100-p7_b))/2;
	p7_c = p7_c*p7_c/c7_;
	p1_fit_L = p1_a*exp(-0.5*((time1_1-p1_b)./p1_c).^2);
	p1_fit_R = p1_a*exp(-0.5*((time1_2-p1_b)./p1_c/(skew_factor/(100-abs(100-p1_b))) ).^2);
	p2_fit_L = p2_a*exp(-0.5*((time2_1-p2_b)./p2_c).^2);
	p2_fit_R = p2_a*exp(-0.5*((time2_2-p2_b)./p2_c/(skew_factor/(100-abs(100-p2_b))) ).^2);
	p3_fit_L = p3_a*exp(-0.5*((time3_1-p3_b)./p3_c).^2);
	p3_fit_R = p3_a*exp(-0.5*((time3_2-p3_b)./p3_c/(skew_factor/(100-abs(100-p3_b))) ).^2);
	p4_fit   = p4_a*exp(-0.5*((time-p4_b)./p4_c).^2);
	p5_fit_L = p5_a*exp(-0.5*((time5_1-p5_b)./p5_c/(skew_factor/(100-abs(100-p5_b))) ).^2);
	p5_fit_R = p5_a*exp(-0.5*((time5_2-p5_b)./p5_c).^2);
	p6_fit_L = p6_a*exp(-0.5*((time6_1-p6_b)./p6_c/(skew_factor/(100-abs(100-p6_b))) ).^2);
	p6_fit_R = p6_a*exp(-0.5*((time6_2-p6_b)./p6_c).^2);
	p7_fit_L = p7_a*exp(-0.5*((time7_1-p7_b)./p7_c/(skew_factor/(100-abs(100-p7_b))) ).^2);
	p7_fit_R = p7_a*exp(-0.5*((time7_2-p7_b)./p7_c).^2);
	p1_fit = [p1_fit_L p1_fit_R];
	p2_fit = [p2_fit_L p2_fit_R];
	p3_fit = [p3_fit_L p3_fit_R];
	p5_fit = [p5_fit_L p5_fit_R];
	p6_fit = [p6_fit_L p6_fit_R];
	p7_fit = [p7_fit_L p7_fit_R];
	fitted = p1_fit+p2_fit+p3_fit+p4_fit+p5_fit+p6_fit+p7_fit;

if (show ~= 0)
%----------------------------------------------------------------------
% show fitting in process.
figure(show);
% show data being fit.
plot(data,'x-','color',[0.75 0.75 1]);
hold on;
title('hexasomy');
% show fit lines.
plot(p1_fit,'-','color',[0 0.75 0.75],'lineWidth',2);
plot(p2_fit,'-','color',[0 0.75 0.75],'lineWidth',2);
plot(p3_fit,'-','color',[0 0.75 0.75],'lineWidth',2);
plot(p4_fit,'-','color',[0 0.75 0.75],'lineWidth',2);
plot(p5_fit,'-','color',[0 0.75 0.75],'lineWidth',2);
plot(p6_fit,'-','color',[0 0.75 0.75],'lineWidth',2);
plot(p7_fit,'-','color',[0 0.75 0.75],'lineWidth',2);
plot(fitted,'-','color',[0 0.50 0.50],'lineWidth',2);
hold off;
%----------------------------------------------------------------------
end;

	width = 0.5;
	switch(func_type)
		case 'cubic'
			Error_Vector = (fitted).^2 - (data).^2;
			sse          = sum(abs(Error_Vector));
		case 'linear'
			Error_Vector = (fitted) - (data);
			sse          = sum(Error_Vector.^2);
		case 'log'
			Error_Vector = log(fitted) - log(data);
			sse          = sum(abs(Error_Vector));
		case 'fcs'
			Error_Vector = (fitted) - (data);
			%Error_Vector(1:round(G1_b*(1-width))) = 0;
			%Error_Vector(round(G1_b*(1+width)):end) = 0;
			sse          = sum(Error_Vector.^2);
		otherwise
			error('Error: choice for fitting not implemented yet!');
			sse          = 1;            
	end;
end
