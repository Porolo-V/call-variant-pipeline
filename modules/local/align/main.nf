process ALIGN {
    publishDir "${params.outdir}/aligned", mode: 'copy'

    input:
    tuple val(meta), path(r1), path(r2)
    tuple path(ref), path(index_files)

    output:
    tuple val(meta), path("${meta.id}.sorted.bam"), path("${meta.id}.sorted.bam.bai"), emit: bam
    path "${meta.id}.flagstat.txt"

    script:
    """
    bwa-mem2 mem -t ${task.cpus} \\
      -R '@RG\\tID:${meta.id}\\tSM:${meta.id}\\tPL:ILLUMINA' \\
      ${ref} ${r1} ${r2} \\
      | samtools sort -@ ${task.cpus} -o ${meta.id}.sorted.bam -
    samtools index ${meta.id}.sorted.bam
    samtools flagstat ${meta.id}.sorted.bam > ${meta.id}.flagstat.txt
    """
}
