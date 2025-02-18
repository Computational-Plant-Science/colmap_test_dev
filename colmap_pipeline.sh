# Summary: 3D reconstruction pipeline using Colmap based on CUP or GPU on HPC(Puma)
# Author: Suxing Liu
# Create date: 02202025

# feature extraction
colmap feature_extractor \
   --database_path $OUTPUT/database.db \
   --image_path $INPUT/ --SiftExtraction.gpu_index=0
   
   
# feature matching
colmap exhaustive_matcher \
   --database_path $OUTPUT/database.db --SiftMatching.gpu_index=0

mkdir $OUTPUT/sparse


# build sparse model
colmap mapper \
    --database_path $OUTPUT/database.db \
    --image_path $INPUT/ \
    --output_path $OUTPUT/sparse

mkdir $OUTPUT/dense

colmap image_undistorter \
    --image_path $INPUT/ \
    --input_path $OUTPUT/sparse/0 \
    --output_path $OUTPUT/dense \
    --output_type COLMAP \
    --max_image_size 2000


# build dense model
colmap patch_match_stereo \
    --workspace_path $OUTPUT//dense \
    --workspace_format COLMAP \
	--PatchMatchStereo.cache_size=32 \
	--PatchMatchStereo.window_step=2 \
	--PatchMatchStereo.window_radius=3 \
	--PatchMatchStereo.num_iterations=3 \
	--PatchMatchStereo.num_samples=10 \
    --PatchMatchStereo.geom_consistency True \
	--PatchMatchStereo.gpu_index=0


# stereo fusion
colmap stereo_fusion \
    --workspace_path $OUTPUT/dense \
    --workspace_format COLMAP \
    --input_type photometric \
    --output_path $OUTPUT/dense/fused.ply

mv $OUTPUT/dense/fused.ply  $OUTPUT/dense.ply
