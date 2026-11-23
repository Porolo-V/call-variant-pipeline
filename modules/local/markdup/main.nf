process MARKDUP {
    publishDir "${params.outdir}/aligned", mode: 'copy'

    input:
    tuple val(meta), path(bam), path(bai)

    output:
    tuple val(meta), path("${meta.id}.dedup.bam"), path("${meta.id}.dedup.bam.bai"), emit: bam
    path "${meta.id}.dedup.flagstat.txt"
    path "${meta.id}.coverage.tsv"

    script:
    """
    samtools sort -n -@ ${task.cpus} ${bam} \\
      | samtools fixmate -m - - \\
      | samtools sort -@ ${task.cpus} - \\
      | samtools markdup -r - ${meta.id}.dedup.bam
    samtools index ${meta.id}.dedup.bam
    samtools flagstat ${meta.id}.dedup.bam > ${meta.id}.dedup.flagstat.txt
    samtools coverage ${meta.id}.dedup.bam > ${meta.id}.coverage.tsv
    """
}
