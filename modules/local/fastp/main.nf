process FASTP {
    publishDir "${params.outdir}/trimmed", mode: 'copy'

    input:
    tuple val(meta), path(reads)

    output:
    tuple val(meta), path("${meta.id}_R1.trim.fastq.gz"), path("${meta.id}_R2.trim.fastq.gz"), emit: reads
    path "${meta.id}.fastp.json", emit: json
    path "${meta.id}.fastp.html"

    script:
    """
    fastp \\
      --in1 ${reads[0]} --in2 ${reads[1]} \\
      --out1 ${meta.id}_R1.trim.fastq.gz --out2 ${meta.id}_R2.trim.fastq.gz \\
      --detect_adapter_for_pe \\
      --cut_right --cut_window_size 4 --cut_mean_quality 20 \\
      --qualified_quality_phred 20 --length_required 50 \\
      --thread ${task.cpus} \\
      --json ${meta.id}.fastp.json --html ${meta.id}.fastp.html
    """
}
