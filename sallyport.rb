require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-timestamps'
require 'net/smtp'
require 'erector'
require 'fileutils'

include Erector::Mixin



#load allows inclusion of stuff in other files which is reloaded on each request
#in development mode
load 'sallyportviews.rb'

enable :sessions
#------------Region for database-------------->
DataMapper.setup(:default,{:adapter=>'sqlite3',:database=>"#{Dir.pwd}/db/sallyport.db"})


class Image
include DataMapper::Resource
property :id, Integer, :serial=>true
property :type, String#extension; jpg,png etc - id +type will give filename!
property :name, String
property :event, String
property :year, Integer
property :comment, String
property :portrait, TrueClass, :default=>false
timestamps :created_at
end

class Event
include DataMapper::Resource
property :id, Integer, :serial=>true
property :name, String
property :where, String
property :wherelink, String
property :when, Date
property :start, String
property :duration, String
property :description, Text
property :report, Text
property :eventlink, String
property :yes, String
property :no, String
property :maybe, String
property :confirmed, String ,:default=>'maybe'
end

class Post
	include DataMapper::Resource
	property :id, Integer, :serial=>true
	property :member_id, Integer
	property :title, String
	property :content, Text
	has n, :comments
	belongs_to :member
	timestamps :created_at
end

class Comment
	include DataMapper::Resource
	property :id, Integer, :serial=>true
	property :member_id, Integer
	property :post_id, Integer
	property :content, Text
	
	belongs_to :post
	belongs_to :member
end


class Member
include DataMapper::Resource
property :id, Integer, :serial=>true
property :fname, String
property :sname, String
property :email, String
property :phone, String
property :username, String
property :password, String
property :type, String
has n, :comments
has n, :posts
end

class Blurb
	include DataMapper::Resource
	property :id, Integer, :serial=>true
	property :name, String
	property :content, Text
end


Image.auto_upgrade!
Event.auto_upgrade!
Member.auto_upgrade!
Post.auto_upgrade!
Comment.auto_upgrade!
Blurb.auto_upgrade!

#-------Database region Ends -------------------|
#-------Filters------------------------------------>


#-------Filters region ends----------------------|


#-------Controllers------------------------------->

#--------helpers----------------------------------->

def auth
	if session["member"]
		return Member.get(session["member"]).type	
	else
		return false
	end
end

def flash
  session[:flash] = {} if session[:flash] && session[:flash].class != Hash
  session[:flash] ||= {}
end




#---------------------------------------------------|

#---------main region----------------------------->

get '/' do
  intro=Blurb.first(:name=>'Homepage')
  intros=intro.content.split("\n")
   page=Index.new(intros, flash[:notice]).to_s
  flash.clear
  page
  end
  
  get '/dance/:dance' do |d|
choices=("Winlaton,Newbiggin,Swalwell,Beadnell,Murton").split(",")
  rapper=Blurb.first(:name.like=>"%"+choices[d.to_i-1]+"%")
 title=rapper.name
   desc=rapper.content.split("\n")
  page=Dance.new(title,desc, flash[:notice]).to_s
  flash.clear
  page
  end

get '/login' do
	if auth
		redirect 'news'
		else
	page=Login.new.to_s
	flash.clear
	page
	end
end

post '/login' do
	
	member=Member.first(:username=>params["username"])
	
	if member
		
		if member.password==params[:password]
			
			session['member']=member.id
			authized=auth
			flash[:notice]="Hi "+member.username+"- You are logged in"
			news=Post.all(:created_at.gt=>Date.today-100, :order=>[:created_at.desc])
			page=News.new(news,authized,flash[:notice]).to_s
			flash.clear
			page
			else
				flash[:notice]='Not Allowed'
				redirect '/'
		end
	else
		flash[:notice]='Not Allowed'
		redirect '/'
	end
end

get '/logout' do
	session['member']=false
	session['user']=nil
	flash[:notice]='Logged Out'
	redirect '/'
end
#--------------------------------------------|
#------------Blurb Region------------------>
get '/blurb' do
	authized=auth
	if authized=='admin'
		blurb=Blurb.all
		page=BlurbShow.new(:blurb=>blurb, :auth=>authized, :note=>flash[:notice]).to_s
		flash.clear
		page
	else
		flash[:notice]="Not Authorized"
		redirect '/'
	end
end

get '/newblurb' do
	authized=auth
	if authized=='admin'
		page=NewBlurb.new(:auth=>authized, :note=>flash[:notice]).to_s
		flash.clear
		page
	else
		flash[:notice]='Not Authorized'	
redirect '/'
	end
end

post '/newblurb' do 
	blurb=Blurb.new
	blurb.name=params['name']
	blurb.content=params['content']
	 if blurb.save
		 flash[:notice]='Saved!'
	redirect '/blurb'
	else
		flash[:notice]='Problem saving new blurb'
	end
	
end

get '/editblurb/:id' do |id|
	authized=auth
	if authized=='admin'
		blurb=Blurb.get(id)
		page =EditBlurb.new(:blurb=>blurb, :auth=>authized, :note=>flash[:notice]).to_s
		flash.clear
		page
	else
		flash[:notice]='Not Allowed'
		redirect '/'
	end
end

post '/blurbupdate/:id' do |id|
	blurb=Blurb.get(id)
	blurb.name=params['name']
	blurb.content=params['content']
	 if blurb.save
		 flash[:notice]='Saved!'
	redirect '/blurb'
	else
		flash[:notice]='Problem saving blurb'
	end
end






#--------------------------------------------|
#------------news region------------------->
get '/news' do
	authized=auth
	unless authized
	flash[:notice]="Members Only"
		redirect '/'
	else
	news=Post.all(:created_at.gt=>Date.today-100, :order=>[:created_at.desc])
	page=News.new(news, authized, flash[:notice]).to_s
	flash.clear
	page
	end
end




get '/newsadmin' do
	authized=auth
	unless authized='admin'
	flash[:notice]="Admin Only"
		redirect '/'
	else
	news=Post.all(:created_at.gt=>Date.today-100, :order=>[:created_at.desc])
	page=Newsall.new(news,authized,flash[:notice]).to_s
	flash.clear
	page
	end
end


get '/newsdestroy/:id' do |this|
	authized=auth
	unless authized
	flash[:notice]="Members Only"
		redirect '/'
	else
	post=Post.get!(this)
	if post.destroy
		flash[:notice]="News Item  - Gone!"
		else
			flash[:notice]="problem-still there!"
		end
	redirect '/news'
	end
end


get '/newsitem/:id' do |this|
	authized=auth
	unless authized
	flash[:notice]="Members Only"
		redirect '/'
	else
		member=Member.get(session['member'])
	item=Post.get!(this)
	comments=item.comments
	page=Newsitem.new(item, comments, member,authized, flash[:notice]).to_s
	flash.clear
	page
	end
end

post '/comment/:item' do |i|
	authized=auth
	unless authized
	flash[:notice]="Members Only"
		redirect '/'
	else
	item=Post.get(i.to_i)
	item.comments.build(:content=>params["comment"],:member_id=>session["member"])
	item.save
	flash[:notice]="Comment created"
	redirect '/newsitem/'+item.id.to_s
	end
end

get '/commentdelete/:cmt' do |cmt|
	authized=auth
	unless authized
	flash[:notice]="Members Only"
		redirect '/'
	else
	member=Member.get(session['member'])
	comment=Comment.get(cmt.to_i)
	item=Post.get(comment.post_id)
	comment.destroy
	comments=item.comments
	page=Newsitem.new(item,comments,member,authized,flash[:notice]).to_s
	flash.clear
	page
	end
end

get '/newnews' do
	unless auth
	flash[:notice]="Members Only"
		redirect '/'
	else
	page=Newnews.new.to_s
	flash.clear
	page
	end
end

post '/newnews' do
	unless auth
	flash[:notice]="Members Only"
		redirect '/'
	else
	member=Member.get(session["member"])
	member.posts.build(:title=>params["title"],:content=>params["content"])
		if member.save
			flash[:notice]="News Created!"
		redirect '/news'
		else
			flash[:notice]='problem - not created'
			redirect 'newnews'
		end
	
	end
end
#------------------------------------------|
#------------members region------------->

get '/newmember' do
	authized=auth
	if authized=='admin'
	page=Newmember.new(:auth=>authized, :note=>flash[:notice]).to_s
	flash.clear
	page
	else
		flash[:notice]='not allowed'
		redirect '/'
	end
	
end

post '/newmember' do
	unless auth
	flash[:notice]="Members Only"
		redirect '/'
	else
	member=Member.new
	member.attributes=params
		if member.save
		flash[:notice]="We Have a New Member!: "+ member.username
		redirect '/showmembers'
	
		else
			flash[:notice]="Failed!"
			redirect '/news'
		end
	end
end

get '/profile' do |id|
	authized=auth
	if authized == false
	flash[:notice]="Not Allowed"
	redirect '/'
	end
	
	member=Member.get(session["member"])
	Editmember.new(:member=>member, :auth=> authized, :note=>flash[:notice]).to_s
end


get '/showmembers' do
	authized=auth
	unless authized=="admin"
	flash[:notice]="Admin Only"
		redirect '/'
	else
	members=Member.all
	page=(Showmembers.new :members=>members,:auth=>authized, :note=>flash[:notice] ).to_s
	flash.clear
	page
	end
end

get '/showmemberdetails' do
	authized=auth
	unless auth
	flash[:notice]="Not Allowed"
		redirect '/'
	else
	members=Member.all
	page=Memberdetails.new(:members=>members,:auth=>authized,:note=>flash[:notice]).to_s
	flash.clear
	page	
	end
	
end

get '/destroymember/:id' do |memid|
	unless auth=="admin"
	flash[:notice]="Admin Only"
		redirect '/'
	else
		member=Member.get(memid.to_i)
		member.destroy
		redirect '/showmembers'
	
	end
end

get '/editmember/:id' do |id|
	authized=auth
	unless authized=="admin"
	flash[:notice]="Admin Only"
		redirect '/'
	else
	member=Member.get(id.to_i)
	page=Editmember.new(:auth=>authized, :member=>member, :note=>flash[:notice]).to_s
	flash.clear
	page
	end
end

post '/editmember/:id' do |id|
member=Member.get(id.to_i)

member.attributes=params
if member.save
	flash[:notice]="Saved!"
		if auth=='admin'
			redirect '/showmembers'
		else
			redirect '/news'
		end
	else
		flash[:notice]="Error! Not saved"
		redirect '/editmember/'+id
end
end

#-----------------------------------------------------------|

#-------------Events region------------------------------->

get '/events' do
	authized=auth
	events=Event.all(:when.gt=>(Date.today-1),:order=>['when'])
	page=Events.new(:events=>events, :auth=>authized, :note=>flash[:notice]).to_s
	flash.clear
	page
end




get '/event/:id' do |id|
	event=Event.get(id.to_i)
	authized=auth
	
	if authized
	if event.yes==nil
		event.yes=""
	end
	if event.no==nil
		event.no=""
	end
	if event.maybe==nil
		event.maybe=""
	end
	
	end
	page=Eventshow.new(:event=>event,:auth=>authized,:note=>flash[:notice]).to_s
	flash.clear

	page
end


get '/newevent' do
	authized=auth
	if authized=='admin'
	Newevent.new(:auth=>authized, :note=>flash[:notice]).to_s
	else
		flash[:notice]='Not Allowed'
		redirect '/'
	end
	
end

post '/newevent' do
	event=Event.new
	event.name=params['name']
	event.where=params['where']
	event.wherelink=params['wherelink']
	
	mday=(params['d1'].to_i*10+params['d2'].to_i)
	mnth=params['month'].to_i
	yr=params['year'].to_i
	at=DateTime.new(yr,mnth,mday)
	event.when=at
	event.start=params['start']
	event.duration=params['duration']
	event.description=params['description']
	event.eventlink=params['eventlink']
	if event.save
		flash[:notice]='Event saved'
		redirect '/events'
		else
		flash[:notice]='Problem...Not Saved'
		redirect '/newevent'	
	end
	
	
end

get '/eventedit/:id' do |id|
	authized=auth
	event=Event.get(id)
	members=Member.all
	page=Eventedit.new(:event=>event,:members=>members, :auth=>authized,:note=>flash[:notice] ).to_s
	flash.clear
	page
end

post '/eventedit/:id' do |id|
event=Event.get(id.to_i)
event.name=params['name']
	event.where=params['where']
	event.wherelink=params['wherelink']
	#-
	mday=(params['d1'].to_i*10+params['d2'].to_i)
	mnth=params['month'].to_i
	yr=params['year'].to_i
	#-
	at=DateTime.new(yr,mnth,mday)
	event.when=at
	event.start=params['start']
	event.duration=params['duration']
	event.description=params['description']
	event.eventlink=params['eventlink']
	if auth=='admin'
	event.yes=params['yes']
	event.no=params['no']
	event.maybe=params['maybe']
	end
	if event.save
		flash[:notice]='Event saved'
		
		else
		flash[:notice]='Problem...Not Saved'
		
	end
	redirect '/event/'+event.id.to_s
end

get '/addname/*/*' do 
	going=params[:splat][0]
	event=params[:splat][1]
	event=Event.get(event.to_i)
	member=Member.get(session['member']).username
	reg=/#{member}/
	
	if event.yes==nil
		event.yes=""
	end
	if event.no==nil
		event.no=""
	end
	if event.maybe==nil
		event.maybe=""
	end
	
	case going
		when 'yes'
		# if yes do nowt, else add to yes and remove from no,maybe if necessary
			if event.yes =~ reg 
			flash[:notice]="Already going"
			else
				event.yes+=member+','
				if event.no=~reg
					event.no.sub!(reg,"")
					event.no.gsub!(/,,/,',')
				end
				if event.maybe=~reg
					event.maybe.sub!(reg,"")
					event.maybe.gsub!(/,,/,',')
				end
				flash[:notice]=member+" is going to "+event.name
			end
		when 'maybe'
		if event.maybe =~ reg 
			flash[:notice]="Already a maybe"
			else
				event.maybe+=member+','
				if event.no=~reg
					event.no.sub!(reg,"")
					event.no.gsub!(/,,/,',')
				end
				if event.yes=~reg
					event.yes.sub!(reg,"")
					event.yes.gsub!(/,,/,',')
				end
				flash[:notice]=member +" is undecided about "+event.name
		end
		when 'no'
		if event.no =~ reg 
			flash[:notice]="Already a no"
			else
				event.no+=member+','
				if event.maybe=~reg
					event.maybe.sub!(reg,"")
					event.maybe.gsub!(/,,/,',')
				
				end
				if event.yes=~reg
					event.yes.sub!(reg,"")
					event.yes.gsub!(/,,/,',')
					
				end
				flash[:notice]=member +" is a no for "+event.name
		end
		
	end
	#clear single commas:
	if event.no==','
		event.no=""
	end
	if event.maybe==','
		event.maybe=""
	end
	if event.yes==','
		event.yes=""
	end
	event.save
	redirect '/event/'+event.id.to_s
	
end

get '/eventsadmin' do
	authized=auth
	if authized=='admin'
	events=Event.all
	page=Eventsadmin.new(:events=>events,:auth=>authized,:note=>flash[:notice]).to_s
	else
	flash[:notice]="Not Allowed"
	redirect '/'
	end
	flash.clear
	page
end

get '/eventdestroy/:id' do |id|
	if auth=='admin'
event=Event.get(id.to_i)
event.destroy
flash[:notice]='event: '+event.name+ 'deleted'
redirect '/eventsadmin'

else
	flash[:notice]='Not Allowed'
	redirect '/'
end
end
#--------------------------------------------------------------|
#--------Images region--------------------------------------->


get '/uploads' do
	authized=auth
	if authized
		page=Uploads.new(:auth=>authized, :note=>flash[:notice]).to_s
	else
		flash[:notice]="Not Allowed"
		redirect '/'
	end
	flash.clear
	page	
end

post '/upload' do
	image=Image.new
	image.name=params[:name]
	image.type=params[:file][:filename].slice(/\.\w+/)
	image.comment=params[:comment]
	image.year=params[:year]
	image.event=params[:event]
	image.portrait=true if params[:portrait]=='checked'
	image.save
	 file = params[:file][:tempfile] 
	 puts file
  File.open("public/images/#{image.id.to_s}#{image.type}", 'wb') {|f| f.write file.read } 
 
	redirect '/gallery'
	
end

get '/gallery' do
	authized=auth
	images=Image.all :created_at.gt=>(Date.today-100), :order=> [:created_at.desc]
	page=Gallery.new(:images=>images, :auth=>authized, :note=>flash[:notice]).to_s
	flash.clear
	page
	
end

post '/searchpics' do
	authized=auth
	name=params['name']
	event=params['event']
	year=params['year']
	#cope with multiple search terms
	if (name !="" and event !="" and year !="")
	images=Image.all( :name.like=> name,:event.like=>event , :year.like=>year)
	elsif  (name !="" and event !="" )
		images=Image.all( :name.like=> "%"+name+"%" , :event.like=>event )
	elsif (name !="" and year !="")
		images=Image.all( :name.like=> "%"+name+"%" , :year.like=>year)
	elsif (event !="" and year !="")
		images=Image.all( :event.like=>"%"+event+"%" ,:year.like=>year)
	elsif event !=""
		images=Image.all(  :event.like=>"%"+event+"%" )
	elsif name !=""
		images=Image.all( :name.like=> "%"+name+"%" )
	elsif year !=""
		images=Image.all(  :year.like=>year)
	else
			flash[:notice]="You have not put in any search terms, try again!"
			redirect '/gallery'
		end#if
		if images.length==0
			flash[:notice]="None found! Try a different search."
			redirect '/gallery'
			else
		page=Gallery.new(:images=>images, :auth=>authized, :note=>flash[:notice]).to_s
	flash.clear
	page
	end
end

get '/imageadmin' do
	authized=auth
	if authized=='admin'
	images=Image.all
	page=ImageAdmin.new(:images=>images, :auth=>authized, :note=>flash[:notice]).to_s
	flash.clear
	page
	else
		flash[:notice]="Not Allowed"
		redirect '/'
	end
	
end

get '/image/:id' do |img|
	authized=auth
	if authized=='admin'
	image=Image.get(img)
	picref='/images/'+ image.id.to_s + image.type.to_s
	page=ImageShowMeta.new(:image=>image, :picref=>picref, :auth=>authized, :note=>flash[:notice]).to_s
	flash.clear
	page
	else
		flash[:notice]="Not allowed"
		redirect '/'
	end
end


post '/image/:id' do |id|
	image=Image.get(id)
	image.name=params['name']
	image.event=params['event']
	image.year=params['year']
	image.comment=params['comment']
	image.portrait=true if params['portrait']=='on'
	image.save
	redirect '/imageadmin'
end

get '/imagepopup/:id' do |id|
	image=Image.get(id)
str="<html><img src='/images/"+image.id.to_s+image.type.to_s
str+="' height=200 width=300 />"
str+="<script>setTimeout('window.close()',10000);</script>"
str+="</html>"
str
	
end

get '/imagedestroy/:id' do |id|
	if auth=='admin'
		image=Image.get(id)
		url=Dir.pwd+'/public/images/'+image.id.to_s+image.type
		if image.destroy
			File.delete(url)
			flash[:notice]="Deleted!"
			redirect '/imageadmin'
		else
			flash[:notice]="Problem - Not Deleted"
			redirect '/imageadmin'
		end
	else
		flash[:notice]='Not Authorized'
		redirect '/'
	end
	
end

