function ButttonDownFcn(src,event)
% window button down function callback
    pt = get(gca,'CurrentPoint');
    x = pt(1,1);
    y = pt(1,2);

fprintf('x=%f,y=%f\n',x,y);