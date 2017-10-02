%Experiment to evaluate accuracy of PA
%Vary:
% dimension, sample size
% number and strength of factors
% delocalization of factors
%% Set parameters
n_mc = 1e1;
rng(2);
n = 500;
p = 300;
m = 1;
num_selected = zeros(n_mc,1);

%% Effect of signal strength
%Plot mean and +/-sd of number of factors selected as a function of signal
%strength

rng(2);
l = 10;
%theta_arr = linspace(0.1,1,l);
gamma  = p/n;
sig=linspace(0.2,6,l);
theta_arr =  gamma^(1/2)*sig;
mean_num_selected =  zeros(l,1);
var_num_selected =  zeros(l,1);
for k=1:l
    theta = theta_arr(k); %factor strength
    for i=1:n_mc
        Lambda = randn(p,m);
        Lambda = normc(Lambda);
        ep = randn(n,p);
        eta  = randn(n,m);
        eta  = normc(eta);
        X =theta*eta*Lambda'+n^(-1/2)*ep;
        s = svd(X);
        
        X_perm= zeros(n,p);
        %get eigenvalues of permutations
        for j=1:p
            pe = randperm(n);
            X_perm(:,j) = X(pe,j);
        end
        s_perm = svd(X_perm);
        num_selected(i) = sum(s>s_perm(1));
    end
    mean_num_selected(k) = mean(num_selected);
    var_num_selected(k) = var(num_selected);
end


%%
rng(2);
savefigs =1;
sd_num_selected = var_num_selected.^(1/2);
figure,
errorbar(sig,mean_num_selected,sd_num_selected,'linewidth',3,'color',rand(1,3))
xlabel('Signal Strength')
ylabel('# Factors Selected')
set(gca,'fontsize',20)
xlim([min(sig), max(sig)]);

if savefigs==1
    filename = sprintf( './PA-n=%d-p=%d-n-iter=%d.png',n,p,n_mc);
    saveas(gcf, filename,'png');
    fprintf(['Saved Results to ' filename '\n']);
    %close(gcf)
end
