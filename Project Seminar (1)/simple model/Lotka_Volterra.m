
function predator_prey_gui_v2

% Figure for program
fig = figure('numbertitle','off','name','Predator-Prey Dynamics',...
    'menubar','none','resize','on','position', [50 30 1050 700]);

% Creation of subplots

% ODEs vs Time
axes('units','pixels','Position',[50 500 500 175],'tag','axes1');
% Phase portrait of x and y
axes('units','pixels','Position',[70 205, 300 250],'tag','axes2');
% ODE image
axes('units','pixels','Position',[600 340 418 322],'tag','axes4');

% Creation of editable text boxes

% Initial conditions
uicontrol('style','edit','string','1000','position',[280 100 75 25],...
    'tag','x');
uicontrol('style','edit','string','500','position',[280 70 75 25],...
    'tag','y');

% Variables
uicontrol('style','edit','string','2','position',[560 220 75 25],...
    'tag','a');
uicontrol('style','edit','string','3','position',[560 180 75 25],...
    'tag','b');
uicontrol('style','edit','string','0.001','position',[560 140 75 25],...
    'tag','c');
uicontrol('style','edit','string','0.006','position',[560 100 75 25],...
    'tag','d');
% Creation of text labels

% Inital conditions text labels
uicontrol('style','text','string','Initial Conditions:','position',[10 100 200 30],...
    'fontsize',16,'horizontalalignment','left');
uicontrol('style','text','string','x(0) =','position',[220 100 50 25],...
    'fontsize',12,'foregroundcolor',[0 0 1],'horizontalalignment','right');
uicontrol('style','text','string','y(0) =','position',[220 70 50 25],...
    'fontsize',12,'foregroundcolor',[0 0 1],'horizontalalignment','right');

% Variables text labels
uicontrol('style','text','string','Variables:','position',[500 250 200 30],... 
    'fontsize',16,'horizontalalignment','left');
uicontrol('style','text','string','a =','position',[500 220 50 25],...
    'fontsize',12,'foregroundcolor',[0 0 1],'horizontalalignment','right');
uicontrol('style','text','string','b =','position',[500 180 50 25],...
    'fontsize',12,'foregroundcolor',[0 0 1],'horizontalalignment','right');
uicontrol('style','text','string', 'c =','position',[500 140 50 25],...
    'fontsize',12,'foregroundcolor',[0 0 1],'horizontalalignment','right');
uicontrol('style','text','string', 'd =','position',[500 100 50 25],...
    'fontsize',12,'foregroundcolor',[0 0 1],'horizontalalignment','right');

% Run button
uicontrol('style','pushbutton','string' ,'RUN','position',[700 280 100 30],...
    'tag','run');

% Callback
handles = guihandles(fig);
guidata(fig,handles);
hca = struct2cell(handles);
for w = 1:length(hca)
    obj = hca{w};
    if isfield(obj,'callback') | isprop(obj,'callback')
        set(obj,'callback',{@main_cb,handles});
    end
end

axes(handles.axes4)
ODEimage =  imread('equation.png');
image(ODEimage)
axis off
axis image

% Perform operations
function main_cb(uiobject, eventdata, handles)
tag = get(uiobject,'tag'); % get control object's tag
switch tag
    case 'run'
        % default values
        a = 2; b = 3; c = 0.001; d = 0.006;
        % update params, ic and time vector based on user input
        a = eval(get(handles.a, 'String'));
        b = eval(get(handles.b, 'String'));
        c = eval(get(handles.c, 'String'));
        d = eval(get(handles.d, 'String'));
        xy0 = [eval(get(handles.x, 'String')), eval(get(handles.y, 'String'))]';
        tvec = [0:0.05:4]
        % define ODEs
        predatorprey = @(t,y) [(a-c*y(2))*y(1); (-b+d*y(1))*y(2)];
        % solve
        [t xy] = ode45(predatorprey,tvec,xy0);
        % plot
        axes(handles.axes1);
        plot(t, xy)
        axis([0 max(tvec(:)) 0 max(xy(:))]); xlabel('t'); legend('x', 'y')
        axes(handles.axes2);
        plot(xy(:,1),xy(:,2))
        title('Phase Plane Plot')
        xlabel('Prey Population')
        ylabel('Predator Population')
end