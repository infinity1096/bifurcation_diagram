
r_list = 0:0.001:4;
conv_val = cell(size(r_list));

for n = 1:size(r_list,2)

    % simulation setup
    max_iters = 1000;
    initial_x = 0.5;
    x = initial_x;
    
    r = r_list(n);
    x_next = @(t) r*t*(1-t);

    % array for result
    x_log = zeros(1,max_iters + 1);
    x_log(1) = x;

    for i = 1:max_iters
        x = x_next(x);
        x_log(i + 1) = x;
    end

    % record convergence value
    conv_check_iter = 800;
    delta = 1e-5; % value to be considered in different group
    conv_dat = x_log(1 + conv_check_iter : max_iters + 1);
    is_near = abs(conv_dat' - conv_dat) < delta;
    c = zeros(size(conv_dat));
    total_num_groups = 0;

    while(sum(c == 0) ~= 0)
        total_num_groups = total_num_groups + 1;

        i = find(c == 0,1,'first');
        c(is_near(i,:)) = total_num_groups; % group id
    end

    % find convergence value by taking average
    z = zeros(1,total_num_groups);
    for i = 1:total_num_groups
        z(i) = mean(conv_dat(c == i));
    end
    conv_val{n} = z;
    fprintf("done for r = %f\n",r);
end

fprintf("generating plot ...\n");
% plotting
figure;
for i = 1:size(conv_val,2)
    h = plot(r_list(i),conv_val{i},'.','Color',[0 0.4470 0.7410]);
    set(h,'markersize',1);
    hold on;
end
xlabel("r");
ylabel("convergence value");
title("convergence value for x_{n+1} = r * x_n * (1 - x_n)");

