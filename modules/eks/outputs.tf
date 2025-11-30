output "cluster_name" {
  value = aws_eks_cluster.cluster.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "cluster_certificate_authority" {
  value = aws_eks_cluster.cluster.certificate_authority[0].data
}

output "node_role_arn" {
  value = aws_iam_role.node_role.arn
}

output "cluster_role_arn" {
  value = aws_iam_role.cluster_role.arn
}
