%Plots with PA
%% Set parameters
rng(2);
n = 500;
p = 300;
m = 1;
rng(2);
gamma  = p/n;
theta =  gamma^(1/2)*3;
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

%% Scree
rng(2);
savefigs =1; a = {'-','--','-.',':'};
figure, hold on
h1 = plot((1:p),s,'linewidth',3,'color',rand(1,3));
set(h1,'LineStyle',a{2});
h2 = plot((1:p),s_perm,'linewidth',2,'color',rand(1,3));
set(h2,'LineStyle',a{1});

xlabel('k')
ylabel('\sigma_k')
set(gca,'fontsize',20)
legend([h1,h2],{'X','X_\pi'},'location','Best')

if savefigs==1
    filename = sprintf( './PA-scree-n=%d-p=%d.png',n,p);
    saveas(gcf, filename,'png');
    fprintf(['Saved Results to ' filename '\n']);
    close(gcf)
end

%% Heatmap
% eta = sort(eta);
% Lambda = sort(Lambda);
savefigs =1; a = {'-','--','-.',':'};
eta = (1:n)';
eta = eta-mean(eta)*ones(n,1);
Lambda = (1:p)';
Lambda = Lambda-mean(Lambda)*ones(p,1);
S = eta*Lambda';
h = HeatMap(S,'RowLabels',(1:n),'ColumnLabels', (1:p));
plot(h)
if savefigs==1
    filename = sprintf( './PA-sig-heat-n=%d-p=%d.png',n,p);
    saveas(gcf, filename,'png');
    fprintf(['Saved Results to ' filename '\n']);
    close(gcf)
end

S_p= zeros(n,p);
for j=1:p
    pe = randperm(n);
    S_p(:,j) = S(pe,j);
end
h = HeatMap(S_p,'RowLabels',(1:n),'ColumnLabels', (1:p));
plot(h)
if savefigs==1
    filename = sprintf( './PA-perm-heat-n=%d-p=%d.png',n,p);
    saveas(gcf, filename,'png');
    fprintf(['Saved Results to ' filename '\n']);
    close(gcf)
end


