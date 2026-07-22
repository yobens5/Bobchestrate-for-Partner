# Part 7: Testing & Deployment

<p align="center">
  <img src="bobchestrate_part8.png" alt="Bobchestrate - Setup" width="700">
</p>

**Duration:** 20 minutes

**Objective:** Deploy your agent to production

## What You'll Learn

- Deployment best practices
- Monitoring and observability
- Generating webchat embed code
- Production readiness checklist

## Agent Evaluations

Agent evaluation and red-teaming are covered in depth in **[Part 6: Agent Evaluations & Red-Teaming](../part6-agent-evaluation/README.md)**. Complete that part before deploying.

Before moving to the deployment steps below, confirm you have:

- [ ] Created an evaluation dataset and run `orchestrate evaluations quick-eval`
- [ ] Reviewed results and addressed any failing test cases
- [ ] Completed at least one red-teaming pass with `orchestrate evaluations red-teaming`
- [ ] Resolved critical security vulnerabilities

## Deployment

### Step 1: Pre-Deployment Checklist
Before deploying to production, verify:

```markdown
## Pre-Deployment Checklist

### Agent Configuration
- [ ] Agent instructions are clear and comprehensive
- [ ] All required tools are imported and working
- [ ] Knowledge bases are indexed and accessible
- [ ] Collaborator agents are configured correctly
- [ ] LLM model is appropriate for production
- [ ] Agent configuration (hidden, enable_cot) is correct

### Tools
- [ ] All tools have proper input validation
- [ ] Error handling is comprehensive
- [ ] Tools return consistent response formats
- [ ] External API calls have timeout handling
- [ ] Rate limiting is implemented where needed
- [ ] Credentials are properly configured

### Knowledge Bases
- [ ] All documents are up to date
- [ ] Knowledge base is fully indexed
- [ ] Retrieval quality is tested
- [ ] Chunk size and overlap are optimized

### Evaluation
- [ ] Evaluation dataset created with diverse test cases
- [ ] Agent evaluation completed with acceptable scores
- [ ] Vulnerability testing (red teaming) completed
- [ ] No critical security vulnerabilities found
- [ ] Evaluation results documented
- [ ] Improvements implemented based on evaluation

### Security
- [ ] No sensitive data in agent instructions
- [ ] API keys are stored securely
- [ ] Input validation prevents injection attacks
- [ ] Rate limiting is configured

### Performance
- [ ] Response times are acceptable
- [ ] Agent doesn't hit rate limits
- [ ] Knowledge base queries are fast
- [ ] Tool execution is efficient

### Documentation
- [ ] Agent purpose is documented
- [ ] Tool usage is documented
- [ ] Deployment process is documented
- [ ] Troubleshooting guide exists
```

### Step 2: Deploy to Draft Environment

Import all artifacts into your active environment. All imported artifacts land in the **draft** state automatically.

### Option A: Ask Bob first
```
Bob, import all my agent components into the draft environment — tools, knowledge bases, and agents — and verify everything is listed correctly
```
Check that Bob confirms all components imported successfully. If you want to run the commands yourself, use Option B below.

### Option B: Do it yourself (fallback)

```bash
# Import all components (always targets draft state)
orchestrate tools import -k python -f order_status_tool.py
orchestrate tools import -k python -f refund_tool.py
orchestrate knowledge-bases import -f faq-knowledge-base.yaml
orchestrate agents import -f escalation-agent.yaml
orchestrate agents import -f customer-support-agent.yaml

# Verify deployment
orchestrate agents list
orchestrate tools list
orchestrate knowledge-bases list
```

**Note:** In Developer Edition, only the draft environment is available. The `orchestrate agents deploy` command is NOT supported in Developer Edition.

### Step 3: Deploy Your Agent (SaaS/On-Premises Only)

Once you've imported your components in Step 2, deploy the agent to make it available to end users.

### Option A: Ask Bob first
```
Bob, deploy my customer-support-agent and confirm it deployed successfully
```
Check that Bob confirms the deployment. If you want to run the command yourself, use Option B below.

### Option B: Do it yourself (fallback)

```bash
# Deploy the agent (makes it available to end users)
orchestrate agents deploy --name customer-support-agent

# Verify deployment
orchestrate agents list
```

**Important Notes:**
- `orchestrate agents deploy` makes the agent available to end users
- This command is NOT available in Developer Edition
- In Developer Edition, agents are always available after import

### Step 4: Generate Webchat Embed Code

Generate the webchat embed code for your website.

### Option A: Ask Bob first
```
Bob, help me generate and customize the webchat embed code for my agent
```
Check that Bob's output includes the HTML/JavaScript snippet. If not, use Option B below.

### Option B: Do it yourself (fallback)
```bash
# For live environment (production)
orchestrate channels webchat embed \
  --agent-name customer-support-agent \
  --env live

# For draft environment (testing)
orchestrate channels webchat embed \
  --agent-name customer-support-agent \
  --env draft
```

This will output HTML/JavaScript code like:

```html
<script>
  window.wxOConfiguration = {
    orchestrationID: "your-orgID_orchestrationID",
    hostURL: "https://dl.watson-orchestrate.ibm.com",
    rootElementID: "root",
    showLauncher: false,
    deploymentPlatform: "ibmcloud",
    crn: "your-org-crn",
    chatOptions: {
      agentId: "your-agent-id",
      agentEnvironmentId: "your-agent-env-id"
    }
  };

  setTimeout(function () {
    const script = document.createElement("script");
    script.src = `${window.wxOConfiguration.hostURL}/wxochat/wxoLoader.js?embed=true`;
    script.addEventListener("load", function () {
      wxoLoader.init();
    });
    document.head.appendChild(script);
  }, 0);
</script>
```

**Requirements for embedding:**
1. Your HTML page must include `<!DOCTYPE html>` (strict mode)
2. Must have an element with `id="root"` for the chat widget
3. Place the script inside the `<body>` tag
4. Configure security (JWT tokens) for production use

Add this to your website's HTML.

## Monitoring and Observability

### Step 1: Monitor Agent Performance

**Note:** Detailed tracing and monitoring commands are available through the watsonx Orchestrate UI and APIs, but are not currently exposed through the CLI in the same way as other commands.

**Monitoring Approaches:**

1. **Use the watsonx Orchestrate UI:**
   - Navigate to your agent in the UI
   - View conversation history and logs
   - Monitor tool usage and success rates
   - Review error messages and failures

2. **Use Evaluation Framework:**
   ```bash
   # Run regular evaluations to track quality
   orchestrate evaluations quick-eval -c evaluation/config.yaml
   
   # Compare results over time
   diff evaluation/results-week1/ evaluation/results-week2/
   ```

3. **Monitor via Logs:**
   - Check application logs for errors
   - Monitor tool execution times
   - Track API response times
   - Review knowledge base query performance

### Step 2: Key Metrics to Track

Monitor these important metrics:

- **Response Time**: How quickly the agent responds
- **Tool Success Rate**: Percentage of successful tool calls
- **Schema Mismatches**: Tool calls with incorrect parameters
- **Hallucinations**: Fabricated or incorrect information
- **User Satisfaction**: Feedback from end users
- **Escalation Rate**: How often issues are escalated

### Ask Bob to Help:
```
Bob, create a monitoring script that analyzes my agent's performance and identifies issues
```

## Production Best Practices

### 1. Version Control
- Keep all agent YAML files in version control
- Tag releases
- Document changes in each version

### 2. Environment Strategy
- Use draft for development and testing
- Use live for production
- Never test directly in live

### 3. Rollback Plan
- Keep previous versions of agents
- Document rollback procedure
- Test rollback process

### 4. Monitoring
- Set up alerts for errors
- Monitor response times
- Track tool usage
- Review traces regularly

### 5. Maintenance
- Update knowledge bases regularly
- Review and improve agent instructions
- Optimize slow tools
- Add new capabilities based on user needs

## Troubleshooting Production Issues

### Issue: Agent is slow
**Diagnosis:**
- Review evaluation results for response times
- Check tool execution logs
- Monitor knowledge base query performance
- Test with different LLM models

**Solutions:**
- Optimize tool code (reduce API calls, add caching)
- Reduce knowledge base chunk size
- Use faster LLM model (e.g., smaller model for simple tasks)
- Implement response caching for common queries
- Optimize knowledge base indexing

### Issue: Agent gives wrong answers
**Diagnosis:**
- Run evaluation to identify failing test cases
- Review agent instructions for clarity
- Check knowledge base content accuracy
- Verify tool outputs are correct

**Solutions:**
- Update agent instructions with more specific guidance
- Improve knowledge base documents (add missing info, fix errors)
- Fix tool logic and validation
- Add more test scenarios to evaluation dataset
- Use guidelines to enforce specific behaviors

### Issue: Tools failing
**Diagnosis:**
- Check tool error messages in logs
- Verify tool parameters match schema
- Test tools independently
- Check API credentials and connectivity

**Solutions:**
- Verify API credentials are configured correctly
- Check network connectivity to external services
- Review tool error handling and add try-catch blocks
- Check rate limits on external APIs
- Validate tool input parameters before execution

## Continuous Improvement

### 1. Collect Feedback
- Monitor user satisfaction
- Track common questions
- Identify gaps in knowledge base

### 2. Iterate
- Update agent instructions based on feedback
- Add new tools for common requests
- Expand knowledge base
- Improve error handling

### 3. Measure Success
- Response accuracy
- User satisfaction
- Resolution time
- Escalation rate

### Ask Bob to Help:
```
Bob, analyze these conversation logs and suggest improvements to my agent: [paste logs]
```

## Key Takeaways

✅ Comprehensive testing prevents production issues  
✅ Use draft environment for testing, live for production  
✅ Monitor agent performance continuously  
✅ Have a rollback plan ready  
✅ Iterate based on user feedback  

## Congratulations! 🎉

You've completed the workshop and built a production-ready customer support agent!

### What You've Learned:
- ✅ Setting up watsonx Orchestrate
- ✅ Creating and configuring agents
- ✅ Building custom Python tools
- ✅ Integrating knowledge bases
- ✅ Creating agent collaborators
- ✅ Deployment
- ✅ Using Bob as your AI assistant

### Next Steps:
1. Build your own agent for your use case
2. Explore advanced features (MCP servers, custom models)
3. Join the watsonx Orchestrate community
4. Share your creations!

## Additional Resources

- [Production Deployment Guide](https://developer.watson-orchestrate.ibm.com/deployment/production)
- [Monitoring and Observability](https://developer.watson-orchestrate.ibm.com/observability/overview)
- [Best Practices](https://developer.watson-orchestrate.ibm.com/best_practices)
- [Community Forum](https://community.ibm.com/community/user/watsonai/communities/community-home?CommunityKey=7a3dc5ba-3018-452d-9a43-a49dc6819633)

---

**💡 Pro Tip:** Keep using Bob for your ongoing development. Bob can help you maintain, improve, and extend your agents!

**🚀 Ready to build something amazing? Go for it!**


---

### Ready for More? Advanced Exercise Available!

Want to take your skills to the next level? Continue with **Part 8: Multi-agent Orchestration and workflows**

**[Continue to Part 8 →](../part8-multi-agent-orchestration/README.md)**
