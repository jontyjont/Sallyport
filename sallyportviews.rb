module Helpers

def nicedate(d=Date.today)
	out=d.mday.to_s+" "
	out+=Date::MONTHNAMES[d.month]+" "
	out+=d.year.to_s
	return out	
end

end

class Search <Erector::Widget
	
	def content
		div :class=>'search' do
			h2 'Search for Pictures'
	form :action=>@action, :method=>'post' do
		
		widget Inputwidget, :name=>'name', :style=>'size:10;', :label=>'Search by name', :lblclass=>'search', :ipclass=>'search'
		widget Inputwidget, :name=>'year', style=>'size:10;', :label=>'Search by year(4 digits)', :lblclass=>'search', :ipclass=>'search'
		widget Inputwidget, :name=>'event', style=>'size:10;', :label=>'Search by event', :lblclass=>'search', :ipclass=>'search'
		br
		input :type=>'submit', :value=>'Search', :style=>'width:7em;'
	end#form
	end#div
	end#method
	
end#class


class Datewidget <Erector::Widget
	def content
		
	d1='1'
	d2='0'
	mnth='1'
	year=Date.today.year.to_s
		if @date
			d1=@date.mday/10.to_i
			d2=@date.mday-d1*10
			mnth=@date.month
			year=@date.year
		
		end
	
	#-this date widget returns day digits d1 and d2 as well as month and year
	#- note no error checking
	inpstyle='color:#ff8;padding:10px;'
	label 'Day',:for=>'d1',:style=>inpstyle
	
	select :name=>'d1' do
		for i in 0..3
			if i==d1
			option i.to_s, :value=>i, :selected=>'selected'
			else
			option i.to_s, :value=>i 
			end
		end
	end
	select :name=>'d2' do
		for i in 0..9
			if i==d2
			option i.to_s ,:value=>i, :selected=>'selected'
			else
			option i.to_s, :value=>i 
			end
		end
	end
	label 'Month', :for=>'month',:style=>inpstyle
	select :name=>'month' do
	for i in 1..12
		if i==mnth
		option i.to_s, :value=>i, :selected=>'selected'
		else
		option i.to_s, :value=>i	
		end
	end
	end
	label 'Year',:for=>'year',:style=>inpstyle
	select :name=>'year' do 
		for i in 2009..2020
			if i==year
			option i.to_s, :value=>i, :selected=>'selected'
			else
			option i.to_s, :value=>i
			end
		end
	end
	end
	
end


class Inputwidget < Erector::Widget  #:name,:label,:style(optional ignored if nil) :horizontal =>true for layout
	#tidies up the form views by making it easier to do a label and text input
	#vertical layout
	
	
	def content
	label  @label ,:for=> @name , :style=>@style, :class=>@lblclass
	br #unless @horizontal==true
	input :name=>@name, :type=>'text',:value=>@value, :class=>@ipclass
	br #unless @horizontal==true
	end
end

class Layout  < Erector::Widget
	
	
	
	def content
		html { 
		  head {
			link  :rel=>"stylesheet", :type=>"text/css", :media=>"screen",:href=>"/styles.css"
		    script  :src=>"/prototype.js", :type=>"text/javascript"
		    script  :src=>"/scriptaculous.js", :type=>"text/javascript"
		    script  :src=>"/slideshow.js", :type=>"text/javascript"
		    title "Sallyport Sword Dancers"
			}
		  body do
				 div :class=>'banner' do
						   img  :src=>'/images/logo.jpg', :height=>150, :width=>450, :align=>'left'
						   if @note
							   div :id=>'notice' do
								 p @note
							   end
						   end
				end
			  div :class=>'right' do 
				if @auth
					render_sidebar2
				else
					render_sidebar
				end
			end
			div :class=>'main', :id=>'main' do
				 render_body
			   
			end
	   
		  end
		}
	end
        
	def render_sidebar
		
				
		  a "Home" ,:href=>'/' 
		  br
		  a 'Members Only', :href=>'/login'
		  br
		  h3 do
			  u "Dances"
		  end
		  
			  a 'Winlaton', :href=>'/dance/1'
		   br
		   a 'Newbiggin', :href=>'/dance/2'
		   br
		   a 'Swalwell' , :href=>'/dance/3'
		   br
		   a 'Beadnell', :href=>'/dance/4'
		   br
		   a  'Murton', :href=>'/dance/5'
		   br
		   h3 do 
			   u "Sallyport"
		   end
		   
		   a 'Upcoming Events', :href=>'/events'
		   br
		  a 'Gallery', :href=>'/gallery'
	   end
	   
def render_sidebar2
		     
	  h3 do
		  u "Members"
		end
	  
	  a "Home", :href=>'/'
	  br
	  a "Log Out", :href=>'/logout'
	  br
	  a "News", :href=>'/news'
	  br
	  a "Events", :href=>'/events'
	  br
	  a 'Gallery', :href=>'/gallery'
	  br
	  a"Members Details", :href=>'/showmemberdetails'
	  br
	  a"Edit Your Profile", :href=>'/profile'
	  br
	  a "Upload Picture", :href=>'/uploads'
	  br
	  if @auth=="admin"
		  h3  do 
			  u "Admin Only"
			end
		  a"New Event", :href=>'/newevent'
		  br
		  a"New Member", :href=>'/newmember'
		  br
		  a "All Members", :href=>'/showmembers'
		  br
		  a "Admin News", :href=>'/newsadmin'
		  br
		  a "Admin Events", :href=>'/eventsadmin'
		   br
		  a "Admin Images", :href=>'/imageadmin'
		  br
		  a "Admin Blurb", :href=>'/blurb'
	end
  end
	   
	   
	
	def render_body
		p "Awaiting content"
	end
	
	 
	 
	
end

class LayoutPics < Erector::Widget
		
	
	
	def content
		html { 
		  head {
			link  :rel=>"stylesheet", :type=>"text/css", :media=>"screen",:href=>"/styles.css"
		    script  :src=>"/prototype.js", :type=>"text/javascript"
		    script  :src=>"/scriptaculous.js", :type=>"text/javascript"
		    script  :src=>"/gallery.js", :type=>"text/javascript"
		    title "Sallyport Sword Dancers"
			}
		  body do
				 div :class=>'banner' do
						   img  :src=>'/images/logo.jpg', :height=>150, :width=>450, :align=>'left'
						   if @note
							   div :id=>'notice' do
								 p @note
							   end
						   end
				end
			  div :class=>'right' do 
				if @auth
					render_sidebar2
				else
					render_sidebar
				end
			end
			div :class=>'pics', :id=>'main' do
				 render_body
			   
			end
	   
		  end
		}
	end
        
	def render_sidebar
		
				
		  a "Home" ,:href=>'/' 
		  br
		  a 'Members Only', :href=>'/login'
		  br
		  h3 do
			  u "Dances"
		  end
		  
			  a 'Winlaton', :href=>'/dance/1'
		   br
		   a 'Newbiggin', :href=>'/dance/2'
		   br
		   a 'Swalwell' , :href=>'/dance/3'
		   br
		   a 'Beadnell', :href=>'/dance/4'
		   br
		   a  'Murton', :href=>'/dance/5'
		   br
		   h3 do 
			   u "Sallyport"
		   end
		   
		   a 'Upcoming Events', :href=>'/events' 
		   br
		    a 'Gallery', :href=>'/gallery'
	   end
	   
def render_sidebar2
		     
	  h3 do
		  u "Members"
		end
	  
	  a "Home", :href=>'/'
	  br
	  a "Log Out", :href=>'/logout'
	  br
	  a "News", :href=>'/news'
	  br
	  a "Events", :href=>'/events'
	  br
	  a"Members Details", :href=>'/showmemberdetails'
	  br
	  a"Edit Your Profile", :href=>'/profile'
	  br
	  a "Upload Picture", :href=>'/uploads'
	  br
	  a 'Gallery', :href=>'/gallery' 
	  br
	  if @auth=="admin"
		  h3  do 
			  u "Admin Only"
			end
		  a"New Event", :href=>'/newevent'
		  br
		  a"New Member", :href=>'/newmember'
		  br
		  a "All Members", :href=>'/showmembers'
		  br
		  a "Admin News", :href=>'/newsadmin'
		  br
		  a "Admin Events", :href=>'/eventsadmin'
		   br
		  a "Admin Images", :href=>'/imageadmin'
		  br
		  a "Admin Blurb", :href=>'/blurb'
	end
  end
	   
	   
	
	def render_body
		p "Awaiting content"
	end
end




class Index < Layout
	def initialize(intros,note)
		
		super(:intros=>intros,:note=>note)
	end
	
	def render_body
		div  :class=>'viewer', :style=>'height:15em;' do
			img :id=>'viewer',:src=>'/images/morpeth.jpg', :width=>'500', :height=>'350'
		end
		h1 'Sallyport Sword Dancers', :align=>"center"
		script "imagerotate()"
		div :class=>'text' do
			  @intros.each do |para|
			p para
			end
		end
	end
	
	
end


  
  class Dance < Layout
	  def initialize(title,desc,note)
		
		super(:title=>title,:desc=>desc,:note=>note)
	end
	   
	   def render_body
		  
		div :class=>'text2' do
			h3 @title 
			@desc.each do|para|
				p para
			end
		
	end 
	   end
	   
  end
  
class Login < Layout
	
	def render_body
	
		h1 "Members Login"
		form :href=>'/login', :method=>'post' do
			label "User Name", :for=>'username',:style=>'color:#ff8;'
			br
			input :name=>'username',:type=>'text'
			br
			label "Password", :for=>'password',:style=>'color:#ff8;'
			br
			input :name=>'password',:id=>'password',:type=>'password'
			br
			input :class=>'btn',:value =>'Submit' , :type => 'submit'
			br
			a "Cancel", :href=>'/'
		end
	end

end

class BlurbShow <Layout
	
	def render_body
		h1 "Blurb"
		a "New Item", :href=>'newblurb', :class=>'del'
		div :class=>'text2', :style=>'height:200em;' do
			@blurb.each do|blurb|
				h3 do
					a blurb.name, :href=>'/editblurb/'+blurb.id.to_s, :class=>'info'
				end#h3
				paras=blurb.content.split("\n")
				paras.each do |para|
						p para
					end#each
					hr
			end#each
		end#div
		
	end
	
end

class NewBlurb <Layout
	
	def render_body
		h1 'New Blurb'
		form :action=>'/newblurb', :method=>'post' do
			widget Inputwidget, :name=>'name', :label=>'Name:' ,:style=>'color:#ff8;'
			label 'Content:', :for=>'content', :style=>'color:#ff8;'
			br
			textarea "", :name=>'content', :rows=>15, :cols=>60
			br
			input :type=>'submit', :value=>'Submit', :class=>'btn'
		end#form
	
	end
	
end

class EditBlurb <Layout
	
	def render_body
		h1 'New Blurb'
		form :action=>'/blurbupdate/'+@blurb.id.to_s, :method=>'post' do
			widget Inputwidget, :name=>'name', :label=>'Name:',:value=>@blurb.name ,:style=>'color:#ff8;'
			label 'Content:', :for=>'content', :style=>'color:#ff8;'
			br
			textarea @blurb.content, :name=>'content', :rows=>15, :cols=>60
			br
			input :type=>'submit', :value=>'Submit', :class=>'btn'
		end#form
	end
		
end

	 


class News < Layout
	
	def initialize(news,authized,note)
		
		super(:news=>news,:auth=>authized,:note=>note)
	end
	
	def render_body
		div :class=>'del' do
		a 'New News', :href=>'/newnews', :class=>'big'
		end
		h1 "Recent News"
		
		if @news
		@news.each do |post|
			div :class=>'info'do
				h3 do
				a post.title, :class=>'info',:href=>'/newsitem/'+post.id.to_s
				end
				if post.content.length<50
					p post.content
				else
					p post.content.slice(0,50)+"..."
				end
			end
		end
		
		end
	end
	
end

class Newsall < Layout
	
	def initialize(news,authized,note)
		
		super(:news=>news,:auth=>authized,:note=>note)
	end
	
	def render_body
	h1 'All News Items'
	div :class=>'text' do
	table do
	@news.each do |item|
	tr {
		td {
			a item.title, :class=>'del',:href=>'/newsitem/'+item.id.to_s
		}
		td {
			p item.content.slice(0..100)+'...'
		}
		td {
			a'delete', :class=>'del',:href=>'/newsdestroy/'+item.id.to_s
		}
	}
	end

	end
	end	
	end
	
end


class Newsitem < Layout
	def initialize(item,comments,member,authized,note)
		
		super(:item=>item,:comments=>comments, :member=>member,:auth=>authized,:note=>note)
	end
	
	def render_body
		div :class=>'text' do
			h2 {
			u @item.title
			}
			if @auth=='admin' 
				div :class=>'del' do
				a 'delete',:class=>'del',:href=>'/newsdestroy/'+@item.id.to_s
				end
			end
			p @item.content
			p @member.username
			h3 "Comments:"
			div :class=>'minor' do
				@comments.each do|comment|
						hr
						if @member.type=='admin' || comment.member.id==@member.id
						div :class=>'del' do
						a 'delete',:class=>'del',:href=>'/commentdelete/'+comment.id.to_s
						end
						end
						p comment.content
						if comment.member
						p do
						i comment.member.username
						end
						end
				end
				form :action=>'/comment/'+@item.id.to_s, :method=>'post' do
				label "Comment:", :for=>'comment'
				br
				textarea "", :name=>'comment', :rows=>5, :cols=>40
				br
				input :class=>'btn',:type=>'submit', :value=>'Submit'
				end
			end
		end
	end
	
end
	


class Newnews < Layout
	def render_body
	h1'New News and Info'
	form :action=>'/newnews', :method=>'post' do
		label "Title", :for=>'title',:style=>'color:#ff8;'
		br
		input :name=>'title', :type=>'text'
		br
		label "Content", :for=>'content',:style=>'color:#ff8;'
		br
		textarea :name=>'content', :rows=>'20', :cols=>'50' 
		br 
		br
		input :class=>'btn',:value =>'Submit' , :type => 'submit'
	end#form	
	end
	
	
end

class Newmember <Layout
	def render_body
	h1 'New Member'
	form :action=>'/newmember', :method=>'post' do
		widget Inputwidget,:name=>'fname',:label=>'First Name',:style=>'color:#ff8'
		widget Inputwidget,:name=>'sname',:label=>'Surname',:style=>'color:#ff8'
		widget Inputwidget , :name=>'username',:label=>'User Name',:style=>'color:#ff8'
		widget Inputwidget , :name=>'password',:label=>'Password',:style=>'color:#ff8'
		widget Inputwidget , :name=>'email',:label=>'Email Address',:style=>'color:#ff8'
		widget Inputwidget, :name=>'phone',:label=>'Phone',:style=>'color:#ff8'
		label "Type", :for=>'type',:style=>'color:#ff8;'
		br
		select :name=>'type', :size=>4 do
		option "member"
		option "admin"
		end
		br
		br
		input :class=>'btn',:value =>'Submit' , :type => 'submit'
	end#form
	end
	
	
end

class Showmembers < Layout
	def render_body
		h1 'All Members'
	div :class=>'text' do
	table do
		th'Name'
		th 'UserName'
		i=1
		@members.each do|member|
		if i%2==0
			color="#ffa"
		else
			color="#fdd"
		end
		i+=1	
			tr :style=>'background-color:'+color do
			
				td do
				a member.fname ,:class=>'del',:href=>'/editmember/'+member.id.to_s
				end
				td member.username
				td do
				a 'delete',:class=>'del',:href=>'/destroymember/'+member.id.to_s
				end
			end
		end
	end
	
	end
		
	end
	
	
end

class Editmember < Layout
	def render_body
		form :action=>'/editmember/'+@member.id.to_s, :method=>'post' do
		widget Inputwidget,:name=>'fname',:label=>'First Name',:style=>'color:#ff8',:value=>@member.fname
		widget Inputwidget,:name=>'sname',:label=>'Surname',:style=>'color:#ff8',:value=>@member.sname
		widget Inputwidget , :name=>'username',:label=>'User Name',:style=>'color:#ff8',:value=>@member.username
		widget Inputwidget , :name=>'password',:label=>'Password',:style=>'color:#ff8',:value=>@member.password
		widget Inputwidget , :name=>'email',:label=>'Email Address',:style=>'color:#ff8',:value=>@member.email
		widget Inputwidget, :name=>'phone',:label=>'Phone',:style=>'color:#ff8',:value=>@member.phone
		
		if @auth=='admin' 
		label 'Type', :for=>'type',:style=>'color:#ff8;'
		br
		select :name=>'type', :size=>4 do
			if @member.type=='member'	
			option "member", :selected=>'selected'
			option "admin"
			else
			option "member"
			option "admin", :selected=>'selected'	
			end
		end
		br
		end
		br
		input :class=>'btn',:value =>'Submit' , :type => 'submit'
	end#form
	end
	
	
end

class Memberdetails < Layout
	
	def render_body
		h1"Membership Details"
	div :class=>'text' do
	table do
		tr do
		th 'Username'
		th 'Name'
		th  'Surname'
		th 'Phone'
		th 'Email'
		end
		i=1
	@members.each do|member|
		if i%2==0
			color="#ffa"
		else
			color="#fdd"
		end
		i+=1	
		tr :style=>'background-color:'+color  do
			
		td member.username , :class=>'narrow'
		td member.fname , :class=>'narrow'
		td member.sname , :class=>'narrow'
		td member.phone , :class=>'narrow'
		td member.email 
		end
	end
	end
	end
	end
	
	
end

class Events < Layout
	include Helpers
	def render_body
		h1 "Sallyport Events"
	
		if @events
			@events.each do |event|
				div :class=>'info' do
						a :class=>'del',:href=>'/event/'+event.id.to_s do
						h3 event.name
						end
					h4 nicedate(event.when)
					p event.description.slice(0..25)+"..." 
					if event.eventlink=~/http:\/\//
						a 'Link to@event site', :href=>event.eventlink, :class=>'std'
					end
					br
					if event.wherelink=~/http:\/\//
						span do
							text "at: "
							a event.where, :href=>event.wherelink, :class=>'std'
						end
					else
						span "at: "+ event.where
							
					end
				end
			end
		end
	end
	
end

class Eventshow < Layout
	include Helpers
def render_body
div :class=>'text' do
		if @auth=='admin'
			a "edit", :class=>'del',:href=>'/eventedit/'+@event.id.to_s
		end
		h1 @event.name
		span do
			"On: " +
			nicedate(@event.when) +
			" at: "
		end
		if @event.eventlink=~/http:\/\//
			a 'Link to event site', :href=>@event.eventlink, :class=>'std'
		end
		br
		if @event.wherelink=~/http:\/\//
			span do
				text "at: "
				a @event.where, :href=>@event.wherelink, :class=>'std'
			end
		else
			span "at: "+@event.where
				
		end
		span " . Lasts: "+@event.duration+" - starts at: "+@event.start
		br
		br
		p @event.description
		if @auth
			hr
			p  do
			text "Going: " 
			span @event.yes ,:style=>'color:green;'
			end
			a "Add your name to 'going'", :class=>'std',:href=>'/addname/yes/'+@event.id.to_s
			hr
			p  do 
				text "Maybe Going: "
				span @event.maybe, :style=>'color:#a66;'
				end
			a "Add your name to 'maybe'", :class=>'std',:href=>'/addname/maybe/'+@event.id.to_s
			hr
			p  do
				text "Not Going: "
				span @event.no, :style=>'color:red;'
				end
			a"Add your name to 'no'", :class=>'std',:href=>'/addname/no/'+@event.id.to_s
			hr
		end
	
	end#divtext
end#method
end#class

class Newevent < Layout
	
	def render_body
		form :action=>'/newevent', :method=>'post' do
	h1 'New Event'
	inpstyle='color:#ff8;padding:10px;'
	#------------------------
	div :class=>'column' do
	widget Inputwidget, :name=>'name', :style=>inpstyle, :label=>'Event Name', :value=>""
	widget Inputwidget, :name=>'where', :style=>inpstyle,:label=>"Where event is to be", :value=>""
	br
	widget Inputwidget ,:name=>'wherelink', :style=>inpstyle, :label=>"Link to map page if available", :value=>""
	
	widget Datewidget, :date=>nil
	br
	br
	widget Inputwidget, :name=>'duration', :style=>inpstyle, :label=>'Duration in hours or days, please state', :value=>""
	widget Inputwidget, :name=>'start', :style=>inpstyle, :label=>'Time of start', :value=>""
	input  :class=>'btn', :type=>'submit', :value=>'Submit'
		
	end#divcolumn
	#-----------------------
	div :class=>'column' do
	label 'Description of event',:for=>'description', :style=>inpstyle
	br
	textarea "", :name=>'description', :padding=>10, :rows=>12, :cols=>'30'
	br
	widget Inputwidget, :name=>'eventlink', :style=>inpstyle, :label=>'Link to event page if available', :value=>""
	
	end#form
	end#div
	end
		
end


class Eventedit < Layout
	
	def render_body
	form :action=>'/eventedit/'+@event.id.to_s, :method=>'post' do
	h1 'Edit Event'
	inpstyle='color:#ff8;padding:10px;'
	#------------------------
	div :class=>'column' do
	widget Inputwidget, :name=>'name', :style=>inpstyle, :label=>'Event Name', :value=>@event.name
	widget Inputwidget, :name=>'where', :style=>inpstyle,:label=>"Where event is to be", :value=>@event.where
	br
	widget Inputwidget ,:name=>'wherelink', :style=>inpstyle, :label=>"Link to map page if available", :value=>@event.wherelink
	
	widget Datewidget, :date=>@event.when
	br
	br
	widget Inputwidget, :name=>'duration', :style=>inpstyle, :label=>'Duration in hours or days, please state', :value=>@event.duration
	widget Inputwidget, :name=>'start', :style=>inpstyle, :label=>'Time of start', :value=>@event.start
	input  :class=>'btn', :type=>'submit', :value=>'Submit'
		if @auth=='admin'
			ul do
		@members.each do|member|
			li member.username
			end
			end#ul
		end#if
	end#divcolumn
	#-----------------------
	div :class=>'column' do
	label 'Description of event',:for=>'description', :style=>inpstyle
	br
	textarea @event.description, :name=>'description', :padding=>10, :rows=>12, :cols=>'30'
	br
	widget Inputwidget, :name=>'eventlink', :style=>inpstyle, :label=>'Link to event page if available', :value=>@event.eventlink
	if @auth=='admin'
	widget Inputwidget, :name=>'yes', :style=>inpstyle, :label=>'yesses', :value=>@event.yes
	widget Inputwidget, :name=>'no', :style=>inpstyle, :label=>'nos', :value=>@event.no
	widget Inputwidget, :name=>'maybe', :style=>inpstyle, :label=>'maybes', :value=>@event.maybe
	
	end
	end#form
	end#div
	end#method
	
	
end#class

class Eventsadmin < Layout
	
	def render_body
		h1 "All Events"
	div :class=>'text' do
	table do
		tr do
		th 'Name'
		th 'Description'
		th 'When'
		end#tr
		i=1
	@events.each do|event|
		if i%2==0
			color="#ffa"
		else
			color="#fdd"
		end
		i+=1	
		tr :style=>'background-color:'+color do	
			
		td :class=>'narrow'do
		a event.name, :class=>'del',:href=>'/event/'+event.id.to_s
		end#td
		td event.description 
		td event.when, :class=>'narrow'
		td  do 
			a 'delete', :class=>'del', :href=>'/eventdestroy/'+event.id.to_s 
			end#td
		end#tr
	end#events
	end#table
	end#div
	end
	
end

class Uploads < Layout
	
	def render_body
		inpstyle='color:#ff8;padding:10px;'
		h1 "Upload a picture" 
		p "You can upload a picture as long as it has a standard extension i.e jpg, png, gif etc. Please add as much detail as you can in the other fields which will be stored along with the picture", :style=>'color:white' 
		form :action=>'/upload', :method=>'post', :enctype=>'multipart/form-data'  do
			div :style=>'float:right;width:300;text-align:left'do
				3.times do
					br
					end
				input :type=>'file', :name=>'file'
				br
				input :type=>'submit', :class=>'btn',:value=>'Upload'
				br
			end#div
			div :style=>'width:200;padding:30;'do
				widget Inputwidget, :name=>'name', :label=>'Name', :style=>inpstyle
				widget Inputwidget, :name=>'event', :label=>'Event(if it has one)', :style=>inpstyle
				widget Inputwidget, :name=>'year', :label=>'Year taken, 4 digit e.g.1969 or 2009', :style=>inpstyle
				label "Portrait?", :for=>'portrait'
				input :type=>'checkbox', :name=>'portrait'
				br
				label "Comments", :for=>'comment', :style=>inpstyle
				br
				textarea "", :name=>'comment', :rows=>10, :cols=>30
				br
			end#div
		end#form
	end#method
		
end

class Gallery < LayoutPics
	
	def render_body
		div  :class=>'viewer' do
			widget Search, :action=>'/searchpics'
			img :id=>'viewer',:name=>'viewer', :src=>'', :width=>'600', :height=>'400', :style=>'display:none;'
			div :class=>'imgmeta' , :id=>'meta' do
				text ""
				end
		end#div
		div :id=>'slideshow' do
			p "Slideshow: "
			end
		div :class=>'btn', :onClick=>'slideshow();' do
				text 'start/stop'
				end#div
		javascript  do
			count=@images.length
			text "var pics = new Array("+count.to_s+");"
			text "var imageinfo = new Array("+count.to_s+");"
			
			for i in 0..count-1 do
				 rawtext "var info"+i.to_s+" = new Array(5);"
				 rawtext  "pics[#{i}]=new Image();"
				 rawtext  "pics[#{i}].src='/images/"+@images[i].id.to_s+@images[i].type+"';"
				 rawtext  'info'+i.to_s+'[0]="' +@images[i].name+'";'
				 rawtext 'info'+i.to_s+'[1]="' +@images[i].event+'";'
				 rawtext  'info'+i.to_s+'[2]="' +@images[i].year.to_s+'";'
				 rawtext 'info'+i.to_s+'[3]="' +@images[i].portrait.to_s+ '";'
				 rawtext  'info'+i.to_s+'[4]="' +@images[i].comment+'";'
				 rawtext 'imageinfo['+i.to_s+'] =info'+i.to_s+';'
				end#for
				
		end#js
		javascript do
		text "loadPic();"
		end#js
	
end#method

end#class

class ImageShowMeta < Layout
	
	def render_body
		
		h1 'Edit Image Details'
		div :class=>'column' do
			if @image.portrait
			img :src=>@picref, :height=>300, :width=>200
			else
			img :src=>@picref, :height=>200, :width=>300
			end#if
		end#div
		div :class=> 'column' do
			form :action=>'/image/'+@image.id.to_s, :method=>'post' do
				widget Inputwidget, :name=>'name', :label=>'Name:', :style=>'color:#ff8;', :value=>@image.name
				widget Inputwidget, :name=>'event', :label=>'Event', :style=>'color:#ff8;', :value=>@image.event
				widget Inputwidget, :name=>'year', :label=>'Year:', :style=>'color:#ff8;', :value=>@image.year
				label 'Comments:' , :for=>'comment',:style=>'color:#ff8;'
				br
				textarea @image.comment, :name=>'comment', :rows=>10, :cols=>30
				br
				br
				label 'Portrait? ', :style=>'color:#ff8;'
				if @image.portrait
				input :name=>'portrait', :type=>'checkbox', :checked=>'checked'
				else
				input :name=>'portrait', :type=>'checkbox'
			end
			br
				input :type=>'submit', :class=>'btn', :value=>'Update'
			end#form
		end#div
		
	end
		
end


class ImageAdmin < Layout
	
	def render_body
		h1 "All Images"
	div :class=>'text' do
	table do
		tr do
		th 'Name'
		th 'Event'
		th 'Year'
		th 'Comments'
		th 'Portrait?'
		end#tr
		i=1
	@images.each do|image|
		if i%2==0
			color="#ffa"
		else
			color="#fdd"
		end
		i+=1	
		tr :style=>'background-color:'+color do	
			
		td :class=>'narrow'do
		a image.name, :class=>'del',:href=>'/image/'+image.id.to_s
		end#td
		td image.event
		td image.year, :class=>'narrow'
		td image.comment
		td image.portrait , :class=>'narrow'
		td  :class=>'narrow' do 
			a 'delete', :class=>'del', :href=>'/imagedestroy/'+image.id.to_s 
		end#td
		imgtype=image.type.downcase
		td :class=>'narrow' ,:name=> "td"+image.id.to_s do
			a 'see', :class=>'del', :onClick=>"window.open('/imagepopup/"+image.id.to_s+"','popup"+image.id.to_s+"','menubar=no, width=320, height=220,screenX=300, screenY=300');"
 
		end#td
		end#tr
	end#events
	end#table
	end#div
	end
	
	
end
