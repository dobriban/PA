%Experiment to evaluate accuracy of PA
%Vary:
% strength of factors
%% Set parameters
n_mc = 1e1;
rng(2);
n = 500;
p = 300;
m = 2;
num_selected = zeros(n_mc,1);

%% Effect of signal strength
%Plot mean and +/-sd of number of factors selected as a function of signal
%strength

rng(2);
l = 20;
gamma  = p/n;
sig1 = 6*ones(l,1);
sig2 = linspace(6,50,l);
theta_arr1 =  gamma^(1/2)*sig1;
theta_arr2 =  gamma^(1/2)*sig2;
mean_num_selected =  zeros(l,1);
var_num_selected =  zeros(l,1);
theta = zeros(2);
for k=1:l
    theta(1,1) = theta_arr1(k); %factor strength
    theta(2,2) = theta_arr2(k); 
    for i=1:n_mc
        Lambda = randn(p,m);
        Lambda = normc(Lambda);
        ep = randn(n,p);
        eta  = randn(n,m);
        eta  = normc(eta);
        X =eta*theta*Lambda'+n^(-1/2)*ep;
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
errorbar(sig2,mean_num_selected,sd_num_selected,'linewidth',3,'color',rand(1,3))
xlabel('Large Signal Strength')
ylabel('# Factors Selected')
set(gca,'fontsize',20)
xlim([min(sig2), max(sig2)]);

if savefigs==1
    filename = sprintf( './PA-shadow-n=%d-p=%d-n-iter=%d.png',n,p,n_mc);
    saveas(gcf, filename,'png');
    fprintf(['Saved Results to ' filename '\n']);
    %close(gcf)
end
