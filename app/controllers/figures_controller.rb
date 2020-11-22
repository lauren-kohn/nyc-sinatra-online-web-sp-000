class FiguresController < ApplicationController
  
  get '/figures' do 
    @figures = Figure.all
    erb :'/figures/index'
  end

  get '/figures/new' do 
    erb :'/figures/new'
  end 

  post '/figures' do 
    @figure = Figure.create(:name => params[:figure][:name])
    @title = params[:title]
    @title_ids = params[:figure][:title_ids]
    @landmark = params[:landmark]
    @landmark_ids = params[:figure][:landmark_ids]
    
    if Title.find_by(:name => params[:figure][:title_ids])
      @figure.titles << Title.find_by(:name => params[:figure][:title_ids])
    else
      @figure.titles << Title.create(:name => params[:figure][:name])
    end

    if Landmark.find_by(:name => params[:figure][:landmark_ids]) 
      @landmark_ids.each do |landmark|
        @figure.landmarks << Landmark.find_by(:name => landmark)
      end
    else 
      @landmark.each do |landmark|
        @figure.landmarks << Landmark.create(:name => landmark, :figure_id => @figure.id)
      end
    end

    redirect to "/figures/#{@figure.id}"
  end

  get '/figures/:id' do 
    @figure = Figure.find(params[:id])
    erb :'/figures/show'
  end 

  get '/figures/:id/edit' do 
    @figure = Figure.find(params[:id])
    erb :'/figures/edit'
  end 

  patch '/figures/:id' do 
    @title = params[:title]
    @title_ids = params[:figure][:title_ids]
    @landmark = params[:landmark][:name]
    @landmark_ids = params[:figure][:landmark_ids]

    @figure = Figure.find_by(params[:id])
    @figure.name = params[:figure][:name]
    @figure.save
      #why is this extra save necessary?
    if Title.find(@title_ids)
      @figure.titles << Title.find(params[:figure][:title_ids])
    else
      @figure.titles << Title.create(:name => @title)
    end
    
    if Landmark.find(params[:figure][:landmark_ids]) 
      @landmark_ids.each do |landmark|
        @figure.landmarks << Landmark.find_by(:name => landmark)
      end
    else 
      landmark = Landmark.create(:name => @landmark)
      @figure.landmarks = landmark
    end
    
    @figure.save
    
    redirect to "/figures/#{@figure.id}"
  end 

end
