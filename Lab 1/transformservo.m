function transformservo(ik)

% DET AR DEN HAR SOM VI KOMMER ATT ANVANDA (version januari)
% Kjell Nordstrom, januari 2004 ITN

if nargin==0,
    ik=0;
    hh=findobj('tag','transformserv');
    fcol=[1 1 1]*0.85;
    if length(hh)==0,
        size=get(0,'ScreenSize');
        set(gcf,'tag','transformserv','un','pix','pos',size+[10 10 -50 -50],'numbertitle','off',...
            'color',fcol,'us',[0 0 0 1 1 0.1 0],'menub','figure','resize','off','pointer','crosshair')
        
        uicontrol('sty','tog','str','start','pos',[20 300 60 60],'backg',fcol,'hor','right','fontsi',14,'fontw',...
            'bold','fontn','chic','callb','transformservo(4);','us',['start';'stop '],'val',0,'tag','starter')
        uicontrol('sty','list','str',['manuell';'P-aterk'],'callb','transformservo(2);','pos',[20 260 90 35],...
            'backg',[1 1 0])
        uicontrol('sty','list','str',['massa=0.5';'massa=2  ';'massa=8  '],'pos',[20 200 90 50],'backg',[0.7 1 0],...
            'callb','transformservo(6);','us',[0.5 2 8])
        
        uicontrol('un','pix','sty','slid','tag','manual controller','pos',[300 200 500 35],'backg',[1 0 0],...
            'val',0,'max',15,'min',-15);
        uicontrol('sty','te','pos',[315 210 230 15],'str','BACK','backg',[1 0.1 0],'hor','cent')
        uicontrol('sty','te','pos',[555 210 230 15],'str','FRAMAT','backg',[1 0.1 0],'hor','cent')
        uicontrol('sty','te','str','Insignal:','pos',[200 200 100 35],'backg',fcol,'hor','rig',...
            'fontsi',16,'fontw','bold','fontn','chic');
        
        uicontrol('sty','slid','tag','Preg','pos',[300 150 500 35],'backg',[0 0 1],'max',15,'min',0)
        uicontrol('sty','te','str','Forstarkning:','pos',[120 150 180 35],'backg',fcol,'hor','rig',...
            'fontsi',16,'fontw','bold','fontn','chic')
        cc=[1 1 0];uicontrol('sty','fr','pos',[20 50 100 30],'tag','bil','backg',[1 0 1]);
        uicontrol('sty','fr','pos',[50 90 850 20],'foreg',cc,'backg',cc);
        uicontrol('sty','fr','pos',[50 20 850 20],'foreg',cc,'backg',cc);
        uicontrol('sty','fr','pos',[550 20 20 90],'foreg',cc,'backg',cc);
        axes('un','pix','pos',[315 200 470 40],'ycolor',fcol,'xlim',[-15 15],'xtick',[-15:3:15],'xcolor',[1 0 0],...
            'color',fcol,'XAxisLocation','top')
        axes('un','pix','pos',[300 150 485 40],'ycolor',[0.85 0.85 0.85],'xlim',[0 15],'xtick',[0:1:15],...
            'xcolor',[0 0 1],'color',[0.85 0.85 0.85],'tickdir','out')
        axes('un','pix','pos',[200 400 500 200],'ytick',[0:0.2:2],'ylim',[0 2],'fontn','times','fontsize',11,...
            'color',[1 1 0.8],'tag','ploty','DrawMode','fast','ylimmode','manual','xlimmode','manual','xgr','on','ygrid','on');        
        line('xdata',0,'ydata',0,'tag','plotta');
    end,
end

% KOD
stat=get(gcf,'us');
tnu=cputime;
bb=findobj('tag','bil');
xx=findobj('tag','manual controller');
bp=get(bb,'pos');
graf=findobj('tag','ploty');
gg=get(xx,'pos');
LL=findobj('tag','plotta');
tidinit=cputime;
tsimu=0;
told=tidinit;
etime=0;
poss=0;
cplot=0;

if stat(4)==1
    kp=1;
else
    kp=get(findobj('tag','Preg'),'val');
end

if ik==4
    ikk=get(gco,'val');
    tx=get(gco,'us');
    set(gco,'str',tx(ikk+1,:));
    stat(7)=ikk;
    if ikk==1
        set(bb,'pos',[20 50 100 30]),
        set(findobj('tag','manual controller'),'val',0);
        stat([1 2 3])=[0 0 0];
        set(LL,'xdata',0,'ydata',0);
    end,
end

if ((ik==6)&&(stat(7)==0)),
    isort=get(gco,'val');
    tau=get(gco,'us');
    stat([5 6])=[isort tau(isort)];
end
if ik==2,stat(4)=get(gco,'val');
end

set(gcf,'currenta',graf);
hold on

zz=findobj('tag','starter');
while stat(7)==1;
    tnu=cputime;
    if stat(4)==1,
        xval=get(0,'pointerl');
        xfig=get(gcf,'pos');
        vala=2*(xval-xfig(1:2)-gg(1:2))./gg(3:4)-1;
        uL=(abs(vala(2))<1)*((abs(vala(1))<1)*vala(1)+(abs(vala(1))>=1)*sign(vala(1)));
        u=14.99*uL;
    elseif stat(4)==2
        uL=kp*(1-stat(1));
        u=(abs(uL)<14.99)*uL+14.99*(abs(uL)>=14.99)*sign(uL);
    end
    tsimu=tsimu+(tnu-told);
    told=tnu;
    if tsimu>0.5e-2,
        stat([1 2])=stat([1 2])+tsimu*[stat(2) (u-stat(2))/stat(6)];tsimu=0;
        bp(1)=20+stat(1)*430;
        set(bb,'pos',bp);
        set(xx,'val',u);
        etime=[etime tnu-tidinit];
        poss=[poss stat(1)];
        pause(0.0001);
        stat(7)=get(zz,'val');
    end
    cplot=cplot+1;
    if ((cplot>50)&&(length(etime)<5000))
        cplot=0;
        met=max(etime);
        met=max(1,met);
        set(graf,'xlim',[0 met],'xtick',[0 met/5 met]);
        set(LL,'xd',etime,'yd',poss);
    end
end

set(gcf,'us',stat),
return,
end