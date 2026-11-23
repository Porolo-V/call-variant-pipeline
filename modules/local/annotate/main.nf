process ANNOTATE {
    publishDir "${params.outdir}/variants", mode: 'copy'

    input:
    tuple val(meta), path(vcf), path(csi)
    path gbk

    output:
    path "${meta.id}.annotated.vcf"
    path "${meta.id}.variants_table.tsv"
    path "${meta.id}.snpEff_summary.html"

    script:
    """
    mkdir -p snpeff_data/REL606
    cp ${gbk} snpeff_data/REL606/genes.gbk
    printf 'data.dir = %s/snpeff_data\\nREL606.genome : REL606\\n' "\$(pwd)" > snpeff.config
    snpEff build -genbank -c snpeff.config REL606

    snpEff -c snpeff.config -stats ${meta.id}.snpEff_summary.html REL606 ${vcf} > ${meta.id}.annotated.vcf

    bcftools query -f '%POS\\t%REF\\t%ALT\\t%QUAL\\t%INFO/DP\\t%INFO/MQ\\t%INFO/ANN\\n' ${meta.id}.annotated.vcf \\
    | awk -F'\\t' 'BEGIN{OFS="\\t"; print "POS","REF","ALT","QUAL","DP","MQ","EFFECT","IMPACT","GENE","PROTEIN_CHANGE","FLAG"}
      {
        split(\$7,e,","); split(e[1],a,"|");
        flag = (\$5 < 30) ? "low_depth" : "";
        print \$1,\$2,\$3,\$4,\$5,\$6,a[2],a[3],a[4],a[11],flag
      }' > ${meta.id}.variants_table.tsv
    """
}
