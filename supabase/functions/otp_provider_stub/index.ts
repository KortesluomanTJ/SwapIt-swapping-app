import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

serve(async (req) => {
  const body = await req.json().catch(() => ({}));
  return new Response(
    JSON.stringify({
      ok: true,
      provider: "stub",
      operation: body.operation ?? "send_or_verify",
      verified: body.code === "000000",
    }),
    { headers: { "Content-Type": "application/json" } },
  );
});
