process MARKDUP {
    publishDir "${params.outdir}/aligned", mode: 'copy'

    input:
    tuple val(id), path(bam), path(bai)

    output:
    tuple val(id), path("${id}.dedup.bam"), path("${id}.dedup.bam.bai"), emit: bam
    path "${id}.dedup.flagstat.txt"
    path "${id}.coverage.tsv"

    script:
    """
    samtools sort -n -@ ${task.cpus} ${bam} \\
      | samtools fixmate -m - - \\
      | samtools sort -@ ${task.cpus} - \\
      | samtools markdup -r - ${id}.dedup.bam
    samtools index ${id}.dedup.bam
    samtools flagstat ${id}.dedup.bam > ${id}.dedup.flagstat.txt
    samtools coverage ${id}.dedup.bam > ${id}.coverage.tsv
    """
}
