import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

serve(async (req) => {
  const payload = await req.json().catch(() => ({}));
  return new Response(
    JSON.stringify({
      ok: true,
      message: "Push dispatch stub. Integrate FCM/APNs/WebPush providers.",
      payload,
    }),
    { headers: { "Content-Type": "application/json" } },
  );
});
