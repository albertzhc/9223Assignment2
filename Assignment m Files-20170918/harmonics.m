function harmonics(option)
%This is a graphical tool to add harmonic cursors to a 
%frequency spectra (x axis must be proportional to real
%frequencies).
%
%Original Program by Dom Ho
%Reprogrammed By Andrew Liew (April 2000)

display_num=7; % <<-- Number of significant figures to display in harmonic cursor value. Added by Wade Smith, 6 February 2013

if nargin==0
   option='init';
end

switch option

case 'init'
   dat.fig=gcf;
   dat.ax=gca;
   set(dat.ax,'drawmode','fast')
   dat.gui=figure('position',[100 100 250 200],...
      'menubar','none',...
      'name','Harmonic Cursor',...
      'numbertitle','off',...
      'resize','off');
   %blank figure
   uicontrol('units','normalized',...
      'position',[0 0 1 1],...
      'style','text');
   
   %colour selection
   uicontrol('units','normalized',...
      'position',[0.05 0.88 0.425 0.1],...
      'string','Colour',...
      'style','text',...
      'fontunits','normalized',...
      'horizontalalignment','center');
   dat.colour=uicontrol('units','normalized',...
      'position',[0.05 0.78 0.425 0.1],...
      'style','popupmenu',...
      'fontunits','normalized',...
      'horizontalalignment','center',...
      'string',{'red','blue','green','cyan',...
         'magenta','yellow','black'});
   
   %linetype selection
   uicontrol('units','normalized',...
      'position',[0.525 0.88 0.425 0.1],...
      'string','Line Type',...
      'style','text',...
      'fontunits','normalized',...
      'horizontalalignment','center');
   dat.ltype=uicontrol('units','normalized',...
      'position',[0.525 0.78 0.425 0.1],...
      'style','popupmenu',...
      'fontunits','normalized',...
      'horizontalalignment','center',...
      'string',{'dotted','dash','dash-dot','solid'});
   
   %Number of Harmonics
   uicontrol('units','normalized',...
      'position',[0.05 0.62 0.425 0.1],...
      'string','No. of Harmonics:',...
      'style','text',...
      'fontunits','normalized',...
      'horizontalalignment','center');
   dat.numharm=uicontrol('units','normalized',...
      'fontunits','normalized',...
      'position',[0.05 0.52 0.425 0.1],...
      'Style','edit',...
      'fontunits','normalized',...
      'string','10');
   
   %Run Button
   uicontrol('units','normalized',...
      'position',[0.525 0.48 0.425 0.12],...
      'style','pushbutton',...
      'string','Run',...
      'horizontalalignment','center',...
      'fontunits','normalized',...
      'callback','harmonics(''run'')');
   
   %delta
   uicontrol('units','normalized',...
      'position',[0.05 0.40 0.425 0.1],...
      'string','Move By:',...
      'style','text',...
      'fontunits','normalized',...
      'horizontalalignment','center');
   dat.delta=uicontrol('units','normalized',...
      'position',[0.05 0.30 0.425 0.1],...
      'style','edit',...
      'fontunits','normalized',...
      'string','0.5');
   
   %Increase and Decrease Buttons
   uicontrol('units','normalized',...
      'position',[0.1 0.12 0.1 0.14],...
      'Style','pushbutton',...
      'string','<',...
      'horizontalalignment','center',...
      'fontunits','normalized',...
      'callback','harmonics(''decrease'')');
   uicontrol('units','normalized',...
      'position',[0.325 0.12 0.1 0.14],...
      'Style','pushbutton',...
      'string','>',...
      'horizontalalignment','center',...
      'fontunits','normalized',...
      'callback','harmonics(''increase'')');
   
   %Refresh Button
   uicontrol('units','normalized',...
      'style','pushbutton',...
      'position',[0.525 0.3 0.425 0.12],...
      'string','Refresh',...
      'fontunits','normalized',...
      'horizontalalignment','center',...
      'callback','harmonics(''refresh'')');
   
   %Erase
   uicontrol('units','normalized',...
      'style','pushbutton',...
      'position',[0.525 0.12 0.425 0.12],...
      'string','Erase All',...
      'horizontalalignment','center',...
      'fontunits','normalized',...
      'callback','harmonics(''erase'')');
   
   %Value on or off
   dat.display=uicontrol('units','normalized',...
      'style','checkbox',...
      'position',[0.525 0.63 0.425 0.1],...
      'string','Display value?',...
      'horizontalalignment','center',...
      'fontunits','normalized');
   
   
   %error Messages
   dat.error=uicontrol('units','normalized',...
      'fontunits','normalized',...
      'position',[0 0 1 0.1],...
      'style','text',...
      'horizontalalignment','center');
   
   dat.hcursor=[];
   dat.disp=[];
   set(gcf,'userdata',dat)

case 'run'
   
   dat=get(gcf,'userdata');
   set(dat.error,'string','');
   
   figure(dat.fig)
   
   c=get(dat.colour,'value');
   switch c
   case 1
      col=[1 0 0];
   case 2
      col=[0 0 1];
   case 3
      col=[0 1 0];
   case 4
      col=[0 1 1];
   case 5
      col=[1 0 1];
   case 6
      col=[1 1 0];
   case 7
      col=[0 0 0];
   otherwise
      col=[1 0 0];
   end
   
   lt=get(dat.ltype,'value');
   switch lt
   case 1
      ltype=':';
   case 2
      ltype='--';
   case 3
      ltype='-.';
   case 4
      ltype='-';
   otherwise
      ltype=':';
   end
   
   numharm=str2num(get(dat.numharm,'string'));
   if isempty(numharm)
      set(dat.error,'string','"No. of Harmonics:" must be a number!')
      figure(dat.gui)
      return
   end
   
   figure(dat.fig)
   
   %Graphically Input the Harmonic Cursor
   temp=get(dat.fig,'Name');
   onoff=get(dat.fig,'Numbertitle');
   set(dat.fig,'Numbertitle','off',...
      'Name','Pick any harmonic and the bottom of cursors:')
   a=ginput(1);
   set(dat.fig,'Numbertitle',onoff,'Name',temp)
   
   %Get the Harmonic Number via dialog box
   temp=inputdlg('Which Harmonic is this?','',1,{'1'});
   if isempty(temp)
      set(dat.error,'string','Run Cancelled!')
      figure(dat.gui)
      return
   end
   while isempty(str2num(temp{1}))
      temp=inputdlg('Must be a number! Which Harmonic is this?');
      if isempty(temp)
         set(dat.error,'string','Run Cancelled!')
         figure(dat.gui)
         return
      end
   end
   harmfreq=a(1)/str2num(temp{1});   
   xharm=harmfreq*ones(size(1:numharm))+harmfreq*(0:1:(numharm-1));
   xlim=get(dat.ax,'Xlim');
   ylim=get(dat.ax,'Ylim');
   if get(dat.display,'value')==1
      if ~isempty(dat.disp)
         delete(dat.disp)
         dat.disp=[];
      end
      dat.disp=text(xlim(1)+0.5*(xlim(2)-xlim(1)),...
         ylim(1)+0.95*(ylim(2)-ylim(1)),...
         ['Harmonic Cursor = ',num2str(xharm(1),display_num),' Hz']);
   else
      if ~isempty(dat.disp)
         delete(dat.disp)
         dat.disp=[];
      end
   end
      
   if isempty(dat.hcursor)
      dat.index=1;
   else
      dat.index=length(dat.hcursor)+1;
   end
   
   for k=1:numharm
      temp=line([xharm(k) xharm(k)],[a(2) ylim(2)],...
         'color',col,'linestyle',ltype);
      dat.hcursor=[dat.hcursor,temp];
   end
   
   %return axis scale
   axis([xlim,ylim])
   figure(dat.gui)
   set(dat.gui,'userdata',dat)
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'increase'
   dat=get(gcf,'userdata');
   set(dat.error,'string','');
   if isempty(dat.hcursor)
      set(dat.error,'string','Must Run First!')
      figure(dat.gui)
      return
   end
   
   delta=str2num(get(dat.delta,'string'));
   if isempty(delta)
      set(dat.error,'string','"Move to:" must be a number!')
      figure(dat.gui)
      return
   end
   
   for Z=dat.index:length(dat.hcursor)
      temp=get(dat.hcursor(Z),'xdata');
      set(dat.hcursor(Z),'xdata',temp+(Z-dat.index+1)*delta);
   end
   
   xlim=get(dat.ax,'Xlim');
   ylim=get(dat.ax,'Ylim');
   if get(dat.display,'value')==1
      if ~isempty(dat.disp)
         delete(dat.disp)
         dat.disp=[];
      end
      temp=get(dat.hcursor(dat.index),'xdata');
      axes(dat.ax)
      dat.disp=text(xlim(1)+0.5*(xlim(2)-xlim(1)),...
         ylim(1)+0.95*(ylim(2)-ylim(1)),...
         ['Harmonic Cursor = ',num2str(temp(1),display_num),' Hz']);
   else
      if ~isempty(dat.disp)
         delete(dat.disp)
         dat.disp=[];
         'isempty'
      end
   end
   figure(dat.gui)
   set(dat.gui,'userdata',dat)
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'decrease'
   dat=get(gcf,'userdata');
   set(dat.error,'string','');
   if isempty(dat.hcursor)
      set(dat.error,'string','Must Run First!')
      figure(dat.gui)
      return
   end
   
   delta=str2num(get(dat.delta,'string'));
   if isempty(delta)
      set(dat.error,'string','"Move to:" must be a number!')
      figure(dat.gui)
      return
   end
   
   for Z=dat.index:length(dat.hcursor)
      temp=get(dat.hcursor(Z),'xdata');
      set(dat.hcursor(Z),'xdata',temp-(Z-dat.index+1)*delta);
   end
   
   xlim=get(dat.ax,'Xlim');
   ylim=get(dat.ax,'Ylim');
   if get(dat.display,'value')==1
      if ~isempty(dat.disp)
         delete(dat.disp)
         dat.disp=[];
      end
      temp=get(dat.hcursor(dat.index),'xdata');
      axes(dat.ax)
      dat.disp=text(xlim(1)+0.5*(xlim(2)-xlim(1)),...
         ylim(1)+0.95*(ylim(2)-ylim(1)),...
         ['Harmonic Cursor = ',num2str(temp(1),display_num),' Hz']);
   else
      if ~isempty(dat.disp)
         delete(dat.disp)
         dat.disp=[];
      end
   end
   figure(dat.gui)
   set(dat.gui,'userdata',dat)
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'erase'
   dat=get(gcf,'userdata');
   set(dat.error,'string','');
   if isempty(dat.hcursor)
      set(dat.error,'string','No cursors to delete!')
      figure(dat.gui)
      return
   end
   delete(dat.hcursor);
   if ~isempty(dat.disp)
      delete(dat.disp);
   end
   
   dat.hcursor=[];
   dat.disp=[];
   figure(dat.gui)
   set(dat.gui,'userdata',dat)
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'refresh'
   %Can add the number of harmonics to be refreshed
   dat=get(gcf,'userdata');
   set(dat.error,'string','');
   if isempty(dat.hcursor)
      set(dat.error,'string','No cursors to refresh!')
      figure(dat.gui)
      return
   end
   c=get(dat.colour,'value');
   switch c
   case 1
      col=[1 0 0];
   case 2
      col=[0 0 1];
   case 3
      col=[0 1 0];
   case 4
      col=[0 1 1];
   case 5
      col=[1 0 1];
   case 6
      col=[1 1 0];
   case 7
      col=[0 0 0];
   otherwise
      col=[1 0 0];
   end
   
   lt=get(dat.ltype,'value');
   switch lt
   case 1
      ltype=':';
   case 2
      ltype='--';
   case 3
      ltype='-.';
   case 4
      ltype='-';
   otherwise
      ltype=':';
   end
   
   set(dat.hcursor(dat.index:length(dat.hcursor)),...
      'color',col,'linestyle',ltype)
   
   xlim=get(dat.ax,'Xlim');
   ylim=get(dat.ax,'Ylim');
   if get(dat.display,'value')==1
      if ~isempty(dat.disp)
         delete(dat.disp)
         dat.disp=[];
      end
      temp=get(dat.hcursor(dat.index),'xdata');
      axes(dat.ax)
      dat.disp=text(xlim(1)+0.5*(xlim(2)-xlim(1)),...
         ylim(1)+0.95*(ylim(2)-ylim(1)),...
         ['Harmonic Cursor = ',num2str(temp(1),display_num),' Hz']);
   else
      if ~isempty(dat.disp)
         delete(dat.disp)
         dat.disp=[];
      end
   end
   figure(dat.gui)
   set(dat.gui,'userdata',dat)
   
end