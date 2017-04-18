# This script merges the content of parsed vcf file to the SNP_CNV file

import os,  sys,  math
import csv

project_folder = sys.argv[1]

snp_cnv_file = os.path.join(project_folder, "SNP_CNV_v1.txt")
parsed_vcf_file = os.path.join(project_folder, "vcf_files", "parsedVCF.txt")
output_file = os.path.join(project_folder, "SNP_CNV_v2.txt")

# opening the files and creating output file
with open(snp_cnv_file, 'r') as snp_cnv, open(parsed_vcf_file, 'r') as parsed_vcf, open(output_file, 'w+') as output:
    # open as csv file
    snp_cnv_reader = csv.reader(snp_cnv, delimiter="\t")
    # open as parsed vcf csv file
    parsed_vcf_reader = csv.reader(parsed_vcf, delimiter="\t")
    # jump header
    next(parsed_vcf_reader)
    # get first line
    parsed_vcf_row = next(parsed_vcf_reader)
    # open output file csv
    writer = csv.writer(output, delimiter="\t", lineterminator="\n")
    for row in snp_cnv_reader:
        # if line needs to be updated updating it
        if (parsed_vcf_row[0] == row[0] and parsed_vcf_row[1] == row[1]):
            total_count = int(row[2])
            # haplotype caller allele frequency is for the reference base
            # calculating new count by multipying the frequencty by read count
            new_count = int(math.ceil(float(parsed_vcf_row[4]) * total_count))
            # update ref count
            if (parsed_vcf_row[2] == 'A'):
                row[4] = new_count
            elif (parsed_vcf_row[2] == 'T'):
                row[5] = new_count
            elif (parsed_vcf_row[2] == 'G'):
                row[6] = new_count
            elif (parsed_vcf_row[2] == 'C'):
                row[7] = new_count
            # update snp count
            if (parsed_vcf_row[3] == 'A'):
                row[4] = total_count - new_count
            elif (parsed_vcf_row[3] == 'T'):
                row[5] = total_count - new_count
            elif (parsed_vcf_row[3] == 'G'):
                row[6] = total_count - new_count
            elif (parsed_vcf_row[3] == 'C'):
                row[7] = total_count - new_count
            # write to output
            writer.writerow(row)
            # fetch next line
            parsed_vcf_row = next(parsed_vcf_reader)
        else:
            # write line as is
             writer.writerow(row)
