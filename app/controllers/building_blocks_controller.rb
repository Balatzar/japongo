class BuildingBlocksController < ApplicationController
  def index
    @building_blocks = BuildingBlock.all
  end

  def show
    @building_block = BuildingBlock.find(params[:id])
  end

  def new
    @building_block = BuildingBlock.new
  end

  def create
    @building_block = BuildingBlock.new(building_block_params)
    if @building_block.save
      redirect_to @building_block, notice: "Building block was successfully created."
    else
      render :new
    end
  end

  def edit
    @building_block = BuildingBlock.find(params[:id])
  end

  def update
    @building_block = BuildingBlock.find(params[:id])
    if @building_block.update(building_block_params)
      redirect_to @building_block, notice: "Building block was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @building_block = BuildingBlock.find(params[:id])
    @building_block.destroy
    redirect_to building_blocks_url, notice: "Building block was successfully destroyed."
  end

  private

  def building_block_params
    params.require(:building_block).permit(:name, :image)
  end
end
