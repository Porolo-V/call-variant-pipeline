include { FASTP } from './modules/local/fastp/main'
include { BWA_INDEX } from './modules/local/bwa_index/main'
include { ALIGN } from './modules/local/align/main'
include { MARKDUP } from './modules/local/markdup/main'
include { CALL_VARIANTS } from './modules/local/call_variants/main'
include { ANNOTATE } from './modules/local/annotate/main'

workflow {
    if (!params.samplesheet) {
        error "Please provide a samplesheet: --samplesheet <file.csv>"
    }

    // one CSV row -> [ meta, [fastq_1, fastq_2] ]
    reads_ch = channel.fromPath(params.samplesheet, checkIfExists: true)
        .splitCsv(header: true)
        .map { row ->
            def meta = [ id: row.sample ]
            tuple(meta, [ file(row.fastq_1, checkIfExists: true), file(row.fastq_2, checkIfExists: true) ])
        }

    // single files shared by ALL samples -> value channels (.first())
    ref_ch = channel.fromPath(params.ref, checkIfExists: true).first()
    fai_ch = channel.fromPath("${params.ref}.fai", checkIfExists: true).first()
    gbk_ch = channel.fromPath(params.gbk, checkIfExists: true).first()

    FASTP(reads_ch)
    BWA_INDEX(ref_ch)
    index_ch = BWA_INDEX.out.index

    ALIGN(FASTP.out.reads, index_ch)
    MARKDUP(ALIGN.out.bam)
    CALL_VARIANTS(MARKDUP.out.bam, index_ch, fai_ch)
    ANNOTATE(CALL_VARIANTS.out.vcf, gbk_ch)
}
