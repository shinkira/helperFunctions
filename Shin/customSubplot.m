function sh = customSubplot(graph_frac_h, graph_frac_v, graph_ratio_h, graph_ratio_v, space_ratio_h, space_ratio_v, extra_panel)

if nargin<4
    error('Not enough argument for customSubplot')
end

if nargin<5
    space_ratio_h = ones(1,length(graph_ratio_h)+1);
    space_ratio_v = ones(1,length(graph_ratio_v)+1);
    space_ratio_h(1) = 2;
    space_ratio_v(1) = 2;
end

if nargin<7
    extra_panel = false;
end

if extra_panel
    graph_ratio_h = [graph_ratio_h,2000];
    space_ratio_h = [space_ratio_h, 1];
end

space_frac_h = 1 - graph_frac_h;
space_frac_v = 1 - graph_frac_v;

n_row = length(space_ratio_v)-1;
n_col = length(space_ratio_h)-1;

for i = 1:n_row
    margin_frac_v(i) = space_frac_v * space_ratio_v(i) / sum(space_ratio_v);
    panel_frac_v(i) = graph_frac_v * graph_ratio_v(i) / sum(graph_ratio_v);
    for j = 1:n_col
        margin_frac_h(j) = space_frac_h * space_ratio_h(j) / sum(space_ratio_h);
        panel_frac_h(j) = graph_frac_h * graph_ratio_h(j) / sum(graph_ratio_h);
        if i==1
            bottom_frac(1) = margin_frac_v(1);
        else
            bottom_frac(i) = sum(margin_frac_v(1:i)) + sum(panel_frac_v(1:i-1));
        end
        if j==1
            left_frac(1) = margin_frac_h(1);
        else
            left_frac(j) = sum(margin_frac_h(1:j)) + sum(panel_frac_h(1:j-1));
        end
        
        if extra_panel && j==n_col && mod(n_row-i+1,length(graph_ratio_v)/2)~=1
            continue
        end
        sh(n_row-i+1,j) = subplot('position',[left_frac(j),bottom_frac(i),panel_frac_h(j),panel_frac_v(i)]);
    end
end