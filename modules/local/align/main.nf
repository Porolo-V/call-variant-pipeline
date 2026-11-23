process ALIGN {
    publishDir "${params.outdir}/aligned", mode: 'copy'

    input:
    tuple val(id), path(r1), path(r2)
    tuple path(ref), path(index_files)

    output:
    tuple val(id), path("${id}.sorted.bam"), path("${id}.sorted.bam.bai"), emit: bam
    path "${id}.flagstat.txt"

    script:
    """
    bwa-mem2 mem -t ${task.cpus} \\
      -R '@RG\\tID:${id}\\tSM:${id}\\tPL:ILLUMINA' \\
      ${ref} ${r1} ${r2} \\
      | samtools sort -@ ${task.cpus} -o ${id}.sorted.bam -
    samtools index ${id}.sorted.bam
    samtools flagstat ${id}.sorted.bam > ${id}.flagstat.txt
    """
}
