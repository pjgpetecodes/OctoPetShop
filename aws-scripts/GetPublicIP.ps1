$ecsTasks = $(aws ecs list-tasks --cluster OctoPetShopCluster1 --region us-east-1) | ConvertFrom-JSON
$ecsTaskARNs = $ecsTasks.taskArns

Foreach ($ecsTaskARN in $ecsTaskARNs)
{
    Write-Host "Task ARN = $ecsTaskARN"
    $ecsTask = $(aws ecs describe-tasks --cluster OctoPetShopCluster1 --region us-east-1 --tasks $ecsTaskARN) | ConvertFrom-JSON

    if ( ($ecsTask.tasks.overrides.containerOverrides[0].name -eq 'shoppingcartservice') -or ($ecsTask.tasks.overrides.containerOverrides[0].name -eq 'web'), ($ecsTask.tasks.overrides.containerOverrides[0].name -eq 'productservice') )
    {
        Write-Host "Found correct Network interface - $ecsTaskARN"
        $networkInterfaceID = $ecsTask.tasks[0].attachments[0].details[1].value
        Write-Host "Network Interface ID = $networkInterfaceID"

        $networkInterface = $(aws ec2 describe-network-interfaces --filters Name=network-interface-id,Values=$networkInterfaceID --region us-east-1) | ConvertFrom-JSON

        $publicIP = $networkInterface.NetworkInterfaces[0].Association.PublicIp
        Write-Host "Public IP is: http://$publicIP"

        break
    }
}