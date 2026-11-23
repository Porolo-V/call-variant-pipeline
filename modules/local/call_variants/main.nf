process CALL_VARIANTS {
    publishDir "${params.outdir}/variants", mode: 'copy'

    input:
    tuple val(meta), path(bam), path(bai)
    tuple path(ref), path(index_files)
    path fai

    output:
    tuple val(meta), path("${meta.id}.filtered.vcf.gz"), path("${meta.id}.filtered.vcf.gz.csi"), emit: vcf
    path "${meta.id}.raw.vcf.gz"

    script:
    """
    bcftools mpileup -Ou -f ${ref} ${bam} \\
      | bcftools call -mv --ploidy ${meta.ploidy} -Oz -o ${meta.id}.raw.vcf.gz
    bcftools index ${meta.id}.raw.vcf.gz
    bcftools filter \\
      -i 'QUAL>${params.min_qual} && INFO/DP>${params.min_dp} && INFO/MQ>${params.min_mq}' \\
      -Oz -o ${meta.id}.filtered.vcf.gz ${meta.id}.raw.vcf.gz
    bcftools index ${meta.id}.filtered.vcf.gz
    echo "raw: \$(bcftools view -H ${meta.id}.raw.vcf.gz | wc -l)  filtered: \$(bcftools view -H ${meta.id}.filtered.vcf.gz | wc -l)"
    """
}
