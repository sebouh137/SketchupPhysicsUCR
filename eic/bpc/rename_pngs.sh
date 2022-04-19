outdir=$HOME/Documents/Overleaf_git/EIC_BPC/figures/sketchup
cp CBlocks_with_EJ200s0001.png $outdir/CBlock.png
cp CBlocks_with_EJ200s0002.png $outdir/BPC.png
cp CBlocks_with_EJ200s0003.png $outdir/layer.png
cp CBlocks_with_EJ200s0004.png $outdir/spiderweb_scint.png
cp BPC0001.png $outdir/endcap.png
cp BPC0002.png $outdir/BPC_closed.png
cp BPC0003.png $outdir/BPC_open.png
cp BPC0004.png $outdir/BPC_open_full_beampipe.png
cp BPC0005.png $outdir/layer_structure.png
cp BPC0006.png $outdir/adjacent.png
cp BPC0007.png $outdir/adjacent_2.png
cp BPC0008.png $outdir/explode_view.png
cp BPC0009.png $outdir/absorber.png
cp BPC0010.png $outdir/scint_cover.png
cp BPC0011.png $outdir/scint_from_upstream.png
cp BPC0012.png $outdir/scint_from_downstream.png
cp BPC0013.png $outdir/pcb.png


cd $outdir
git pull
git add CBlock.png BPC.png layer.png spiderweb_scint.png
git add endcap.png BPC_closed.png BPC_open.png BPC_open_full_beampipe.png layer_structure.png explode_view.png absorber.png scint_cover.png scint_from_upstream.png scint_from_downstream.png pcb.png adjacent_2.png adjacent.png
git commit -m "updated sketchup plots"
git push
