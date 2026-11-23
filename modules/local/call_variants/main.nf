process CALL_VARIANTS {
    publishDir "${params.outdir}/variants", mode: 'copy'

    input:
    tuple val(id), path(bam), path(bai)
    tuple path(ref), path(index_files)
    path fai

    output:
    tuple val(id), path("${id}.filtered.vcf.gz"), path("${id}.filtered.vcf.gz.csi"), emit: vcf
    path "${id}.raw.vcf.gz"

    script:
    """
    bcftools mpileup -Ou -f ${ref} ${bam} \\
      | bcftools call -mv --ploidy 1 -Oz -o ${id}.raw.vcf.gz
    bcftools index ${id}.raw.vcf.gz
    bcftools filter \\
      -i 'QUAL>${params.min_qual} && INFO/DP>${params.min_dp} && INFO/MQ>${params.min_mq}' \\
      -Oz -o ${id}.filtered.vcf.gz ${id}.raw.vcf.gz
    bcftools index ${id}.filtered.vcf.gz
    echo "raw: \$(bcftools view -H ${id}.raw.vcf.gz | wc -l)  filtered: \$(bcftools view -H ${id}.filtered.vcf.gz | wc -l)"
    """
}
