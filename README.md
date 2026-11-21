# call-variant-pipeline

Nextflow pipeline for short-read variant calling, being generalised from a single-organism
workflow to configurable organisms (ploidy, annotation, reference) via config profiles.

Status: work in progress. The starting point is
[ecoli-variant-pipeline v1.0](https://github.com/Porolo-V/ecoli-variant-pipeline/releases/tag/v1.0)
(E. coli, haploid, bash and Nextflow versions, Docker image, CI).

Пайплайн вызова вариантов по коротким ридам. Идёт обобщение с одного организма на
настраиваемые (плоидность, аннотация, референс) через профили конфигурации.
Исходная точка: [ecoli-variant-pipeline v1.0](https://github.com/Porolo-V/ecoli-variant-pipeline/releases/tag/v1.0).

## Run the test

    docker build -t ecoli-varcall:0.2 - < Dockerfile
    nextflow run . -profile test,docker
