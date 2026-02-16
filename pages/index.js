import Head from "next/head";

export default function Home() {
  return (
    <>
      <Head>
        <title>Hello from ATLAS</title>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
      </Head>
      <main style={styles.main}>
        <div style={styles.card}>
          <div style={styles.logoRow}>
            <span style={styles.globe}>&#127760;</span>
            <h1 style={styles.heading}>
              <span style={styles.gradient}>ATLAS</span> shipped this.
            </h1>
          </div>
          <p style={styles.sub}>
            This app was deployed end-to-end by an autonomous AI agent —
            no human touched the dashboard, filled a form, or clicked deploy.
          </p>
          <div style={styles.steps}>
            <Step n="1" text="Code written in Cursor" />
            <Step n="2" text="Pushed to GitHub by ATLAS" />
            <Step n="3" text="Deployed to Vercel by ATLAS" />
            <Step n="4" text="Stripe product + checkout by ATLAS" />
            <Step n="5" text="Customer email sent by ATLAS" />
          </div>
          <a href="/api/checkout" className="cta">
            Buy Atlas Pro — $29/mo
          </a>
          <a
            href="https://github.com/sarishajaitly"
            target="_blank"
            rel="noopener noreferrer"
            style={styles.link}
          >
            Built with ATLAS &mdash; Autonomous Task &amp; Launch Automation System
          </a>
        </div>
      </main>
      <style jsx>{`
        .cta {
          display: inline-block;
          background: linear-gradient(135deg, #7b61ff, #00d4ff);
          color: #fff;
          font-weight: 600;
          padding: 0.9rem 1.8rem;
          border-radius: 12px;
          text-decoration: none;
          margin-bottom: 1.5rem;
          transition: transform 0.2s, box-shadow 0.2s;
        }
        .cta:hover {
          transform: translateY(-2px);
          box-shadow: 0 8px 20px rgba(123, 97, 255, 0.4);
        }
      `}</style>
    </>
  );
}

function Step({ n, text }) {
  return (
    <div style={styles.step}>
      <div style={styles.stepNumber}>{n}</div>
      <span style={styles.stepText}>{text}</span>
    </div>
  );
}

const styles = {
  main: {
    minHeight: "100vh",
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    background: "linear-gradient(135deg, #0f0c29, #302b63, #24243e)",
    fontFamily:
      "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif",
    color: "#e0e0e0",
    padding: "2rem",
  },
  card: {
    background: "rgba(255,255,255,0.06)",
    backdropFilter: "blur(12px)",
    border: "1px solid rgba(255,255,255,0.12)",
    borderRadius: "20px",
    padding: "3rem",
    maxWidth: "600px",
    width: "100%",
    textAlign: "center",
    boxShadow: "0 20px 80px rgba(0,0,0,0.4)",
  },
  logoRow: {
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    gap: "0.75rem",
    marginBottom: "1rem",
  },
  globe: { fontSize: "2.5rem" },
  heading: {
    fontSize: "2.2rem",
    fontWeight: 800,
    letterSpacing: "-0.5px",
    margin: 0,
  },
  gradient: {
    background: "linear-gradient(90deg, #7b61ff, #00d4ff)",
    WebkitBackgroundClip: "text",
    WebkitTextFillColor: "transparent",
  },
  sub: {
    color: "#999",
    fontSize: "1.05rem",
    lineHeight: 1.7,
    margin: "0.5rem 0 2rem",
  },
  steps: {
    display: "flex",
    flexDirection: "column",
    gap: "0.75rem",
    marginBottom: "2rem",
  },
  step: {
    display: "flex",
    alignItems: "center",
    gap: "1rem",
    background: "rgba(123,97,255,0.08)",
    border: "1px solid rgba(123,97,255,0.18)",
    borderRadius: "10px",
    padding: "0.75rem 1.25rem",
    textAlign: "left",
  },
  stepNumber: {
    width: "32px",
    height: "32px",
    borderRadius: "50%",
    background: "linear-gradient(135deg, #7b61ff, #00d4ff)",
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    fontWeight: 700,
    fontSize: "0.9rem",
    color: "#fff",
    flexShrink: 0,
  },
  stepText: {
    fontSize: "0.95rem",
    color: "#ccc",
  },
  link: {
    color: "#7b61ff",
    textDecoration: "none",
    fontSize: "0.85rem",
    opacity: 0.8,
  },
};
