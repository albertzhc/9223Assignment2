function sidebands(option)
%This is a graphical tool to add sideband cursors to a 
%frequency spectra.
%
%Original Program by Dom Ho
%Reprogrammed By Andrew Liew (April 2000)

display_num=8; % <<-- Number of significant figures to display in carrier frequency cursor value. Added by Wade Smith, September 2013
display_num2=9; % <<-- Number of significant figures to display in sideband spacing cursor value. Added by Wade Smith, September 2013


if nargin==0
   option='init';
end

switch option

case 'init'
   dat.fig=gcf;
   dat.ax=gca;
   set(dat.ax,'drawmode','fast')
   dat.gui=figure('position',[100 100 250 250],...
      'menubar','none',...
      'name','Sideband Cursors',...
      'numbertitle','off',...
      'resize','off');
   
   %blank figure
   uicontrol('units','normalized',...
      'position',[0 0 1 1],...
      'style','text');
   
   %colour selection
   uicontrol('units','normalized',...
      'position',[0.05 0.90 0.425 0.08],...
      'string','Colour',...
      'style','text',...
      'fontunits','normalized',...
      'horizontalalignment','center');
   dat.colour=uicontrol('units','normalized',...
      'position',[0.05 0.8 0.425 0.1],...
      'style','popupmenu',...
      'fontunits','normalized',...
      'horizontalalignment','center',...
      'string',{'red','blue','green','cyan',...
         'magenta','yellow','black'});
   
   %linetype selection
   uicontrol('units','normalized',...
      'position',[0.525 0.9 0.425 0.08],...
      'string','Line Type',...
      'style','text',...
      'fontunits','normalized',...
      'horizontalalignment','center');
   dat.ltype=uicontrol('units','normalized',...
      'position',[0.525 0.8 0.425 0.1],...
      'style','popupmenu',...
      'fontunits','normalized',...
      'horizontalalignment','center',...
      'string',{'dotted','dash','dash-dot','solid'});
   
   %Number of sidebands
   uicontrol('units','normalized',...
      'position',[0.05 0.68 0.425 0.08],...
      'string','# of sidebands:',...
      'style','text',...
      'fontunits','normalized',...
      'horizontalalignment','center');
   dat.numsb=uicontrol('units','normalized',...
      'fontunits','normalized',...
      'position',[0.05 0.60 0.425 0.08],...
      'Style','edit',...
      'fontunits','normalized',...
      'string','5');
   
   %Value on or off
   dat.display=uicontrol('units','normalized',...
      'style','checkbox',...
      'position',[0.525 0.7 0.425 0.08],...
      'string','Display value?',...
      'horizontalalignment','center',...
      'fontunits','normalized');

   %Run Button
   uicontrol('units','normalized',...
      'position',[0.525 0.58 0.425 0.1],...
      'style','pushbutton',...
      'string','Run',...
      'horizontalalignment','center',...
      'fontunits','normalized',...
      'callback','sidebands(''run'')');
   
   %Refresh Button
   uicontrol('units','normalized',...
      'style','pushbutton',...
      'position',[0.05 0.46 0.425 0.10],...
      'string','Refresh',...
      'fontunits','normalized',...
      'horizontalalignment','center',...
      'callback','sidebands(''refresh'')');
   
   %Erase
   uicontrol('units','normalized',...
      'style','pushbutton',...
      'position',[0.525 0.46 0.425 0.10],...
      'string','Erase All',...
      'horizontalalignment','center',...
      'fontunits','normalized',...
      'callback','sidebands(''erase'')');
   
   %Separator
   uicontrol('units','normalized',...
      'position',[0 0.42 1 0.005],...
      'style','text',...
      'backgroundcolor',[0 0 0]);
   
   %delta carrier
   uicontrol('units','normalized',...
      'position',[0.05 0.32 0.425 0.08],...
      'string','Move Carrier By:',...
      'style','text',...
      'fontunits','normalized',...
      'horizontalalignment','center');
   dat.delta_c=uicontrol('units','normalized',...
      'position',[0.05 0.24 0.425 0.08],...
      'style','edit',...
      'fontunits','normalized',...
      'string','0.5');
   
   %Increase and Decrease Buttons Carrier
   uicontrol('units','normalized',...
      'position',[0.1 0.10 0.1 0.12],...
      'Style','pushbutton',...
      'string','<',...
      'horizontalalignment','center',...
      'fontunits','normalized',...
      'callback','sidebands(''decrease_c'')');
   uicontrol('units','normalized',...
      'position',[0.325 0.10 0.1 0.12],...
      'Style','pushbutton',...
      'string','>',...
      'horizontalalignment','center',...
      'fontunits','normalized',...
      'callback','sidebands(''increase_c'')');
   %delta carrier
   uicontrol('units','normalized',...
      'position',[0.525 0.32 0.425 0.08],...
      'string','Move sbands By:',...
      'style','text',...
      'fontunits','normalized',...
      'horizontalalignment','center');
   dat.delta_s=uicontrol('units','normalized',...
      'position',[0.525 0.24 0.425 0.08],...
      'style','edit',...
      'fontunits','normalized',...
      'string','0.1');
   
   %Increase and Decrease Buttons sidebands
   uicontrol('units','normalized',...
      'position',[0.575 0.10 0.1 0.12],...
      'Style','pushbutton',...
      'string','<',...
      'horizontalalignment','center',...
      'fontunits','normalized',...
      'callback','sidebands(''decrease_s'')');
   uicontrol('units','normalized',...
      'position',[0.8 0.10 0.1 0.12],...
      'Style','pushbutton',...
      'string','>',...
      'horizontalalignment','center',...
      'fontunits','normalized',...
      'callback','sidebands(''increase_s'')');
   
   %error Messages
   dat.error=uicontrol('units','normalized',...
      'fontunits','normalized',...
      'position',[0 0 1 0.08],...
      'style','text',...
      'horizontalalignment','center');
   
   dat.sbcursor=[];
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
   
   numside=round(str2num(get(dat.numsb,'string')));
   if isempty(numside)
      set(dat.error,'string','"No. of sidebands:" must be a number!')
      figure(dat.gui)
      return
   end
   
   figure(dat.fig)
   
   %Graphically Input the Harmonic Cursor
   temp=get(dat.fig,'Name');
   onoff=get(dat.fig,'Numbertitle');
   set(dat.fig,'Numbertitle','off',...
      'Name','Pick the carrier freqiency and the bottom of cursors:')
   a=ginput(1);
   set(dat.fig,'Numbertitle','off',...
      'Name','pick one of the sidebands')
   b=ginput(1);
   set(dat.fig,'Numbertitle',onoff,'Name',temp)
   
   if isempty(a) | isempty(b)
      set(dat.error,'string','Run Cancelled!')
      figure(dat.gui)
      return
   end
      
   
   %Get the Harmonic Number via dialog box
   temp=inputdlg('Which sideband is this?','',1,{'1'});
   if isempty(temp)
      set(dat.error,'string','Run Cancelled!')
      figure(dat.gui)
      return
   end
   while isempty(str2num(temp{1}))
      temp=inputdlg('Must be a number! Which sideband is this?');
      if isempty(temp)
         set(dat.error,'string','Run Cancelled!')
         figure(dat.gui)
         return
      end
   end
   
   carrfreq=a(1);
   sidebandsfreq=abs(b(1)-a(1))/str2num(temp{1});
   
   xharm=carrfreq+(-numside:numside)*sidebandsfreq;
   
   xlim=get(dat.ax,'Xlim');
   ylim=get(dat.ax,'Ylim');
      
   if isempty(dat.sbcursor)
      dat.index=1;
   else
      dat.index=length(dat.sbcursor)+1;
   end
   
   for k=1:numside*2+1
      temp=line([xharm(k) xharm(k)],[a(2) ylim(2)],...
         'color',col,'linestyle',ltype);
      dat.sbcursor=[dat.sbcursor,temp];
   end
   if get(dat.display,'value')==1
      if ~isempty(dat.disp)
         delete(dat.disp)
         dat.disp=[];
      end
      dat.disp=text(xlim(1)+0.2*(xlim(2)-xlim(1)),...
         ylim(1)+0.95*(ylim(2)-ylim(1)),...
         ['Carrier Freq = ',...
            num2str(xharm(dat.index+numside),display_num),...
            ' Hz, ',...
            'Sideband Spacing = ',...
            num2str(xharm(dat.index+1)-xharm(dat.index),display_num2),...
            ' Hz']);
   else
      if ~isempty(dat.disp)
         delete(dat.disp)
         dat.disp=[];
      end
   end
   
   %return axis scale
   axis([xlim,ylim])
   figure(dat.gui)
   set(dat.gui,'userdata',dat)
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'increase_c'
   dat=get(gcf,'userdata');
   set(dat.error,'string','');
   if isempty(dat.sbcursor)
      set(dat.error,'string','Must Run First!')
      figure(dat.gui)
      return
   end
   
   delta=str2num(get(dat.delta_c,'string'));
   if isempty(delta)
      set(dat.error,'string','"Move to:" must be a number!')
      figure(dat.gui)
      return
   end
   
   for Z=dat.index:length(dat.sbcursor)
      temp=get(dat.sbcursor(Z),'xdata');
      set(dat.sbcursor(Z),'xdata',temp+delta);
   end
   
   xlim=get(dat.ax,'Xlim');
   ylim=get(dat.ax,'Ylim');
   numside=(length(dat.sbcursor)-dat.index)/2;
   if get(dat.display,'value')==1
      if ~isempty(dat.disp)
         delete(dat.disp)
         dat.disp=[];
      end
      temp=get(dat.sbcursor(dat.index),'xdata');
      axes(dat.ax)
      temp=get(dat.sbcursor(dat.index+numside),'xdata');
      temp2=get(dat.sbcursor(dat.index+numside-1),'xdata');
      axes(dat.ax)
      dat.disp=text(xlim(1)+0.2*(xlim(2)-xlim(1)),...
         ylim(1)+0.95*(ylim(2)-ylim(1)),...
         ['Carrier Freq = ',...
            num2str(temp(1),display_num),...
            ' Hz, ',...
            'Sideband Spacing = ',...
            num2str(temp(1)-temp2(1),display_num2),...
            ' Hz']);
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
case 'decrease_c'
   dat=get(gcf,'userdata');
   set(dat.error,'string','');
   if isempty(dat.sbcursor)
      set(dat.error,'string','Must Run First!')
      figure(dat.gui)
      return
   end
   
   delta=str2num(get(dat.delta_c,'string'));
   if isempty(delta)
      set(dat.error,'string','"Move to:" must be a number!')
      figure(dat.gui)
      return
   end
   
   for Z=dat.index:length(dat.sbcursor)
      temp=get(dat.sbcursor(Z),'xdata');
      set(dat.sbcursor(Z),'xdata',temp-delta);
   end
   
   xlim=get(dat.ax,'Xlim');
   ylim=get(dat.ax,'Ylim');
   numside=(length(dat.sbcursor)-dat.index)/2;
   if get(dat.display,'value')==1
      if ~isempty(dat.disp)
         delete(dat.disp)
         dat.disp=[];
      end
      temp=get(dat.sbcursor(dat.index+numside),'xdata');
      temp2=get(dat.sbcursor(dat.index+numside-1),'xdata');
      axes(dat.ax)
      dat.disp=text(xlim(1)+0.2*(xlim(2)-xlim(1)),...
         ylim(1)+0.95*(ylim(2)-ylim(1)),...
         ['Carrier Freq = ',...
            num2str(temp(1),display_num),...
            ' Hz, ',...
            'Sideband Spacing = ',...
            num2str(temp(1)-temp2(1),display_num2),...
            ' Hz']);
   else
      if ~isempty(dat.disp)
         delete(dat.disp)
         dat.disp=[];
      end
   end
   figure(dat.gui)
   set(dat.gui,'userdata',dat)
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'increase_s'
   dat=get(gcf,'userdata');
   set(dat.error,'string','');
   if isempty(dat.sbcursor)
      set(dat.error,'string','Must Run First!')
      figure(dat.gui)
      return
   end
   
   delta=str2num(get(dat.delta_s,'string'));
   if isempty(delta)
      set(dat.error,'string','"Move to:" must be a number!')
      figure(dat.gui)
      return
   end
   
   
   numside=(length(dat.sbcursor)-dat.index)/2;
   for Z=dat.index:length(dat.sbcursor)
      temp=get(dat.sbcursor(Z),'xdata');
      set(dat.sbcursor(Z),'xdata',temp+delta*(Z-dat.index-numside));
   end
   
   xlim=get(dat.ax,'Xlim');
   ylim=get(dat.ax,'Ylim');
   if get(dat.display,'value')==1
      if ~isempty(dat.disp)
         delete(dat.disp)
         dat.disp=[];
      end
      temp=get(dat.sbcursor(dat.index+numside),'xdata');
      temp2=get(dat.sbcursor(dat.index+numside-1),'xdata');
      axes(dat.ax)
      dat.disp=text(xlim(1)+0.2*(xlim(2)-xlim(1)),...
         ylim(1)+0.95*(ylim(2)-ylim(1)),...
         ['Carrier Freq = ',...
            num2str(temp(1),display_num),...
            ' Hz, ',...
            'Sideband Spacing = ',...
            num2str(temp(1)-temp2(1),display_num2),...
            ' Hz']);
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
case 'decrease_s'
   dat=get(gcf,'userdata');
   set(dat.error,'string','');
   if isempty(dat.sbcursor)
      set(dat.error,'string','Must Run First!')
      figure(dat.gui)
      return
   end
   
   delta=str2num(get(dat.delta_s,'string'));
   if isempty(delta)
      set(dat.error,'string','"Move to:" must be a number!')
      figure(dat.gui)
      return
   end
   
   numside=(length(dat.sbcursor)-dat.index)/2;
   for Z=dat.index:length(dat.sbcursor)
      temp=get(dat.sbcursor(Z),'xdata');
      set(dat.sbcursor(Z),'xdata',temp-delta*(Z-dat.index-numside));
   end
   
   xlim=get(dat.ax,'Xlim');
   ylim=get(dat.ax,'Ylim');
   if get(dat.display,'value')==1
      if ~isempty(dat.disp)
         delete(dat.disp)
         dat.disp=[];
      end
      temp=get(dat.sbcursor(dat.index+numside),'xdata');
      temp2=get(dat.sbcursor(dat.index+numside-1),'xdata');
      axes(dat.ax)
      dat.disp=text(xlim(1)+0.2*(xlim(2)-xlim(1)),...
         ylim(1)+0.95*(ylim(2)-ylim(1)),...
         ['Carrier Freq = ',...
            num2str(temp(1),display_num),...
            ' Hz, ',...
            'Sideband Spacing = ',...
            num2str(temp(1)-temp2(1),display_num2),...
            ' Hz']);
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
   if isempty(dat.sbcursor)
      set(dat.error,'string','No cursors to delete!')
      figure(dat.gui)
      return
   end
   delete(dat.sbcursor);
   if ~isempty(dat.disp)
      delete(dat.disp);
   end
   
   dat.sbcursor=[];
   dat.disp=[];
   figure(dat.gui)
   set(dat.gui,'userdata',dat)
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'refresh'
   %Can add the number of harmonics to be refreshed
   dat=get(gcf,'userdata');
   set(dat.error,'string','');
   if isempty(dat.sbcursor)
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
   
   set(dat.sbcursor(dat.index:length(dat.sbcursor)),...
      'color',col,'linestyle',ltype)
   
   xlim=get(dat.ax,'Xlim');
   ylim=get(dat.ax,'Ylim');
   numside=(length(dat.sbcursor)-dat.index)/2;
   if get(dat.display,'value')==1
      if ~isempty(dat.disp)
         delete(dat.disp)
         dat.disp=[];
      end
      temp=get(dat.sbcursor(dat.index+numside),'xdata');
      temp2=get(dat.sbcursor(dat.index+numside-1),'xdata');
      axes(dat.ax)
      dat.disp=text(xlim(1)+0.2*(xlim(2)-xlim(1)),...
         ylim(1)+0.95*(ylim(2)-ylim(1)),...
         ['Carrier Freq = ',...
            num2str(temp(1),display_num),...
            ' Hz, ',...
            'Sideband Spacing = ',...
            num2str(temp(1)-temp2(1),display_num2),...
            ' Hz']);
   else
      if ~isempty(dat.disp)
         delete(dat.disp)
         dat.disp=[];
      end
   end
   figure(dat.gui)
   set(dat.gui,'userdata',dat)
   
end