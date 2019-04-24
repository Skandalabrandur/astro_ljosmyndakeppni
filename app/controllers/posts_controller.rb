class PostsController < ApplicationController
    before_action :set_post, only: [:show, :edit, :update, :destroy]
    # GET /posts
    def index
        if current_user && (current_user.judge || current_user.admin) then
            @posts = Post.all
        else
            redirect_to error_path, notice: 'Þarft að vera dómari til að sjá alla pósta'
        end
    end

    # GET /posts/1
    def show
        unless current_user
            redirect_to error_path, notice: "Aðeins dómarar hafa aðgang að þessu vefsvæði"
        else
            @user = current_user
        end
    end

    def user_show
        @post = Post.find(params[:id])
        if @post.email != params[:email]
            redirect_to error_path, notice: "Þú hefur ekki réttindin til að skoða þessa mynd. Email vantar til sönnunar"
        end
    end

    def rate
        unless current_user && current_user.judge
            redirect_to error_path, notice: 'Getur ekki gefið mynd einkunn nema þú sért dómari'
        else
            unless Post.exists?(id: params[:postid])
                redirect_to error_path, notice: "Mynd með id:#{params[:postid]} fannst ekki"
            else
                unless params[:rating].to_i <= 10 && params[:rating].to_i >= 1
                    redirect_to error_path, notice: "Einkunnargjöf á að vera á bilinu 1-10"
                else
                    if Rating.exists?(user_id: current_user.id, post_id: params[:postid])
                        rating = Rating.find_by(user_id: current_user.id, post_id: params[:postid])
                        rating.value = params[:rating]
                        if rating.save
                            redirect_to root_path, notice: "Uppfærsla á einkunnargjöf tókst"
                        else
                            redirect_to error_path, notice: "Einkunnargjöf mistókst. Ertu að gefa slóða handvirkt?"
                        end
                    else
                        rating = Rating.new(user_id: current_user.id, post_id: params[:postid], value: params[:rating])
                        if rating.save
                            redirect_to root_path, notice: "Einkunnargjöf tókst"
                        else
                            redirect_to error_path, notice: "Einkunnargjöf mistókst. Ertu að gefa slóða handvirkt?"
                        end
                    end
                end
            end
        end
    end

    # GET /posts/new
    def new
        @post = Post.new
    end

    def user_start_page
        unless current_user.nil?
            @user = current_user

            if current_user.admin
                @ratings = Rating.all
                @posts = Post.where(deleted: false)
		if @posts.count == 0
			@posts = []
			@ratings = []
		end

                @post_ratings = Hash.new{0}
                @post_vote_count = Hash.new{0}
                @post_weighted_ratings = Hash.new{0}

		@posts.each do |post|
		    @post_ratings[post.id] = 0
                    @post_weighted_ratings[post.id] = 0
                    @post_vote_count[post.id] = 0
 
		end

                @ratings.each do |rating|
		    unless Post.find(rating.post_id).deleted
                    	@post_ratings[rating.post_id] += rating.value 
                    	@post_weighted_ratings[rating.post_id] += rating.value
                    	@post_vote_count[rating.post_id] += 1
		    end
                end

                @judge_count = 0

                User.all.each do |user|
                    if user.judge
                        @judge_count += 1
                    end
                end

                @post_weighted_ratings.each do |k, v|
                    @post_weighted_ratings[k] = v.to_f / @judge_count
                end

                @posts_sorted_by_weighted_value = @post_weighted_ratings.sort_by { |k, v| v}.reverse
                render :admin_page
            else
                render :judge_page
            end
        else
	    @post = Post.new
            render :new
        end
    end

    # GET /posts/1/edit
    def edit
        if current_user
            @post = Post.new
        else
            render :not_logged_in
        end
    end

    # POST /posts
    def create
        #unless current_user
        #    redirect_to error_path, notice: 'Þarft að vera innskráður notandi til að senda inn mynd'
        #end


        @post = Post.new(post_params)
        @post.deleted = false

        if @post.save
            if Post.where(email: @post.email, deleted: false).count > 3
              y = Post.where(email: @post.email, deleted: false).order(created_at: :asc)[0]
              y.deleted = true
              y.save
              redirect_to "/image/#{@post.id}/#{@post.email}", notice: "VINSAMLEGAST ATHUGIÐ. Þrjár myndir frá þér voru þegar í kerfinu. Elstu myndinni þinni með titilinn '#{y.title}' var eytt úr kerfinu."
            else
              redirect_to "/image/#{@post.id}/#{@post.email}", notice: 'Mynd móttekin.'
            end
        else
            render :new
        end
    end

    # PATCH/PUT /posts/1
    def update
        redirect_to error_path, notice: "Ólögleg aðgerð"
        #if @post.update(post_params)
        #    redirect_to @post, notice: 'Post was successfully updated.'
        #else
        #    render :edit
        #end
    end

    # DELETE /posts/1
    def destroy
        unless current_user && (current_user.judge || current_user.admin)
            redirect_to error_path, notice: "Ólögleg aðgerð. Þarft að vera stjórnandi eða eigandi myndar til að eyða henni"
	else
	        #@post.destroy
		@post.deleted = true
		if @post.save then
	       		redirect_to root_path, notice: 'Mynd var eytt'
		else
			redirect_to error_path, notice: 'Ekki tókst að eyða mynd, vinsamlegast hafðu samband við vefstjórnanda'
		end
        end
   end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
        @post = Post.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
        params.require(:post).permit(:title, :content, :image, :email)
    end
end
