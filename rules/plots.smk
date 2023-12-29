rule tidy_scores:
    input:
        metrics_files=expand(metrics_pattern, workflow=WORKFLOWS, method=METHODS),
    output:
        "outputs/{scenario}/plots/tidy_scores.parquet",
    params:
        metrics_redlist=[
            "pcr",
            "pcr_batch",
            "il_f1",
            "il_asw",
            "negcon_fraction_below_p",
            "negcon_fraction_below_corrected_p",
            "nonrep_fraction_below_p",
            "nonrep_fraction_below_corrected_p",
            "lisi_label",
        ],
        methods_redlist=[],  # ['harmony', 'scanorama', 'mnn', 'combat']
    run:
        plot.figures.tidy_scores(
            input.metrics_files, params.metrics_redlist, params.methods_redlist, *output
        )


rule pivot_scores:
    input:
        "outputs/{scenario}/plots/tidy_scores.parquet",
    output:
        "outputs/{scenario}/plots/pivot_scores.parquet",
    run:
        plot.figures.pivot_scores(*input, *output)


rule barplot_all_metrics:
    input:
        "outputs/{scenario}/plots/tidy_scores.parquet",
    output:
        "outputs/{scenario}/plots/all_metrics_barplot.png",
    run:
        plot.figures.barplot_all_metrics(*input, *output)


rule barplot_map_scores:
    input:
        "outputs/{scenario}/plots/tidy_scores.parquet",
    output:
        "outputs/{scenario}/plots/map_scores_barplot.png",
    run:
        plot.figures.barplot_map_scores(*input, *output)


rule hbarplot_all_metrics:
    input:
        "outputs/{scenario}/plots/pivot_scores.parquet",
    output:
        "outputs/{scenario}/plots/mean_all_metrics_hbarplot.png",
    run:
        plot.figures.hbarplot_all_metrics(*input, *output)


rule umap_batch:
    input:
        embds_files=expand(umap_pattern, workflow=WORKFLOWS, method=METHODS),
        pivot_path="outputs/{scenario}/plots/pivot_scores.parquet",
    output:
        "outputs/{scenario}/plots/umap_batch.png",
    run:
        plot.figures.umap_batch(input.embd_files, input.pivot_path, *output)