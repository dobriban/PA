%Experiment to evaluate accuracy of PA
%Vary:
% delocalization of factors
%% Set parameters
n_mc = 1e2;
rng(2);
n = 500;
p = 300;
m = 1;

%% Effect of deloc_arralization
rng(2);
l = 5;
sparsity_arr = linspace(1/p,10/p,l);
mean_num_selected =  zeros(l,1);
var_num_selected =  zeros(l,1);
theta = 2;
for k=1:l
    sparsity = sparsity_arr(k); %factor strength
    num_selected = zeros(n_mc,1);
    for i=1:n_mc
        Lambda = zeros(p,m);
        Lambda(1:floor(p*sparsity),:) = randn(floor(p*sparsity),m);
        Lambda = normc(Lambda);
        ep = randn(n,p);
        eta  = randn(n,m);
        eta  = normc(eta);
        X = theta*eta*Lambda'+n^(-1/2)*ep;
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
%deloc_arr = (9./(p.*sparsity_arr)).^(1/4);
%deloc_arr = flip(deloc_arr);
%a = flip(mean_num_selected);
%b = flip(sd_num_selected);
figure,
%errorbar(deloc_arr ,a,b,'linewidth',3,'color',rand(1,3))
%xlabel('Localization |\lambda|_4/|\lambda|_2')
errorbar(sparsity_arr ,mean_num_selected,sd_num_selected,'linewidth',3,'color',rand(1,3))
ylabel('# Factors Selected')
xlabel('Sparsity')
set(gca,'fontsize',20)
xlim([min(sparsity_arr), max(sparsity_arr)]);

if savefigs==1
    filename = sprintf( './PA-deloc-arr-n=%d-p=%d-n-iter=%d.png',n,p,n_mc);
    saveas(gcf, filename,'png');
    fprintf(['Saved Results to ' filename '\n']);
    %close(gcf)
end
