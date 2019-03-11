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

    end

    def rate
        unless current_user && current_user.judge
            redirect_to error_path, notice: 'Getur ekki gefið mynd einkunn nema þú sért dómari'
        else
            unless Post.exists?(id: params[:postid])
                redirect_to error_path, notice: "Mynd með id:#{params[:postid]} fannst ekki"
            else
                if Rating.exists?(user_id: current_user.id, post_id: params[:postid])
                    rating = Rating.find_by(user_id: current_user.id, post_id: params[:postid])
                    rating.value = params[:rating]
                    if rating.save
                        redirect_to "/posts/#{params[:postid]}", notice: "Uppfærlsa á einkunnargjöf tókst"
                    else
                        redirect_to error_path, notice: "Einkunnargjöf mistókst. Ertu að gefa slóða handvirkt?"
                    end
                else
                    rating = Rating.new(user_id: current_user.id, post_id: params[:postid], value: params[:rating])
                    if rating.save
                        redirect_to "/posts/#{params[:postid]}", notice: "Einkunnargjöf móttekin"
                    else
                        redirect_to error_path, notice: "Einkunnargjöf mistókst. Ertu að gefa slóða handvirkt?"
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
            render :judge_page

            if current_user.admin
                render :admin_page
            end
        end

        redirect_to "/posts/new"
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

        if @post.save
            redirect_to @post, notice: 'Aðgerð tókst.'
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
        unless current_user && (current_user.id == @post.user_id || current.user.admin)
            redirect_to error_path, notice: "Ólögleg aðgerð. Þarft að vera stjórnandi eða eigandi myndar til að eyða henni"
        end
        @post.destroy
        redirect_to root_path, notice: 'Mynd var eytt'
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
        @post = Post.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
        params.require(:post).permit(:title, :content, :image)
    end
end
