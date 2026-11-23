process BWA_INDEX {
    input:
    path ref

    output:
    tuple path(ref), path("${ref}.*"), emit: index

    script:
    """
    bwa-mem2 index ${ref}
    """
}
