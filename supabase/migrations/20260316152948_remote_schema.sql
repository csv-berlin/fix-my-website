drop extension if exists "pg_net";

create extension if not exists "citext" with schema "public";


  create table "public"."check_results" (
    "id" uuid not null default gen_random_uuid(),
    "scan_id" uuid not null,
    "website_id" uuid not null,
    "page_id" uuid,
    "check_key" text not null,
    "check_category" text not null,
    "severity" text not null,
    "status" text not null,
    "score_impact" numeric(5,2),
    "title" text not null,
    "description" text,
    "recommendation" text,
    "details_json" jsonb,
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."check_results" enable row level security;


  create table "public"."content_blocks" (
    "id" uuid not null default gen_random_uuid(),
    "site_page_id" uuid not null,
    "block_type" text,
    "content_json" jsonb,
    "sort_order" bigint,
    "created_at" timestamp with time zone default now()
      );


alter table "public"."content_blocks" enable row level security;


  create table "public"."profiles" (
    "id" uuid not null,
    "email" public.citext,
    "full_name" text,
    "company_name" text,
    "avatar_url" text,
    "onboarding_completed" boolean not null default false,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


alter table "public"."profiles" enable row level security;


  create table "public"."recommendations" (
    "id" uuid not null default gen_random_uuid(),
    "scan_id" uuid not null,
    "website_id" uuid not null,
    "page_id" uuid,
    "priority" text not null,
    "category" text not null,
    "headline" text not null,
    "explanation" text,
    "how_to_fix" text,
    "estimated_effort" text,
    "expected_impact" text,
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."recommendations" enable row level security;


  create table "public"."scan_pages" (
    "id" uuid not null default gen_random_uuid(),
    "scan_id" uuid not null,
    "website_id" uuid not null,
    "url" text not null,
    "normalized_url" text,
    "status_code" integer,
    "indexable" boolean,
    "title" text,
    "meta_description" text,
    "h1" text,
    "word_count" integer,
    "load_time_ms" integer,
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."scan_pages" enable row level security;


  create table "public"."scans" (
    "id" uuid not null default gen_random_uuid(),
    "website_id" uuid not null,
    "scan_type" text not null default 'full'::text,
    "trigger_type" text not null default 'manual'::text,
    "status" text not null default 'queued'::text,
    "started_at" timestamp with time zone,
    "finished_at" timestamp with time zone,
    "created_by_user_id" uuid,
    "pages_scanned" integer not null default 0,
    "score_overall" numeric(5,2),
    "score_seo" numeric(5,2),
    "score_performance" numeric(5,2),
    "score_accessibility" numeric(5,2),
    "score_content" numeric(5,2),
    "raw_summary_json" jsonb,
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."scans" enable row level security;


  create table "public"."site_briefs" (
    "id" uuid not null default gen_random_uuid(),
    "site_project_id" uuid not null,
    "business_name" text,
    "industry" text,
    "city" text,
    "target_audience" text,
    "services_json" jsonb,
    "usp_text" text,
    "keywords_json" jsonb,
    "tone_of_voice" text,
    "created_at" timestamp with time zone default now()
      );


alter table "public"."site_briefs" enable row level security;


  create table "public"."site_pages" (
    "id" uuid not null default gen_random_uuid(),
    "site_project_id" uuid not null,
    "template_page_id" uuid,
    "name" text,
    "slug" text,
    "sort_order" bigint,
    "created_at" timestamp with time zone default now(),
    "page_type" text,
    "h1" text,
    "meta_title" text,
    "meta_description" text
      );


alter table "public"."site_pages" enable row level security;


  create table "public"."site_projects" (
    "id" uuid not null default gen_random_uuid(),
    "workspace_id" uuid not null,
    "template_id" uuid,
    "site_name" text,
    "created_at" timestamp with time zone default now()
      );


alter table "public"."site_projects" enable row level security;


  create table "public"."subscriptions" (
    "id" uuid not null default gen_random_uuid(),
    "workspace_id" uuid not null,
    "provider" text not null default 'stripe'::text,
    "provider_customer_id" text,
    "provider_subscription_id" text,
    "plan" text not null default 'free'::text,
    "status" text not null default 'active'::text,
    "current_period_start" timestamp with time zone,
    "current_period_end" timestamp with time zone,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


alter table "public"."subscriptions" enable row level security;


  create table "public"."template_pages" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "template_id" uuid,
    "name" text,
    "slug" text,
    "page_type" text,
    "sort_order" bigint
      );


alter table "public"."template_pages" enable row level security;


  create table "public"."templates" (
    "id" uuid not null default gen_random_uuid(),
    "name" text not null,
    "slug" text,
    "category" text,
    "industry" text,
    "description" text,
    "previer_image_url" text,
    "is_active" boolean,
    "created_at" timestamp with time zone
      );


alter table "public"."templates" enable row level security;


  create table "public"."usage_counters" (
    "id" uuid not null default gen_random_uuid(),
    "workspace_id" uuid not null,
    "period_start" date not null,
    "period_end" date not null,
    "scans_used" integer not null default 0,
    "pages_scanned" integer not null default 0,
    "reports_generated" integer not null default 0,
    "storage_bytes_used" bigint not null default 0,
    "updated_at" timestamp with time zone not null default now()
      );


alter table "public"."usage_counters" enable row level security;


  create table "public"."websites" (
    "id" uuid not null default gen_random_uuid(),
    "workspace_id" uuid not null,
    "project_name" text not null,
    "domain" public.citext not null,
    "canonical_domain" text,
    "status" text not null default 'active'::text,
    "industry" text,
    "target_country" text,
    "target_language" text,
    "cms" text,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


alter table "public"."websites" enable row level security;


  create table "public"."workspace_members" (
    "id" uuid not null default gen_random_uuid(),
    "workspace_id" uuid not null,
    "user_id" uuid not null,
    "role" text not null default 'owner'::text,
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."workspace_members" enable row level security;


  create table "public"."workspaces" (
    "id" uuid not null default gen_random_uuid(),
    "owner_user_id" uuid not null,
    "name" text not null,
    "slug" public.citext,
    "plan" text not null default 'free'::text,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


alter table "public"."workspaces" enable row level security;

CREATE UNIQUE INDEX check_results_pkey ON public.check_results USING btree (id);

CREATE UNIQUE INDEX content_blocks_pkey ON public.content_blocks USING btree (id);

CREATE INDEX idx_check_results_check_key ON public.check_results USING btree (check_key);

CREATE INDEX idx_check_results_page_id ON public.check_results USING btree (page_id);

CREATE INDEX idx_check_results_scan_id ON public.check_results USING btree (scan_id);

CREATE INDEX idx_check_results_severity ON public.check_results USING btree (severity);

CREATE INDEX idx_check_results_website_id ON public.check_results USING btree (website_id);

CREATE INDEX idx_recommendations_scan_id ON public.recommendations USING btree (scan_id);

CREATE INDEX idx_recommendations_website_id ON public.recommendations USING btree (website_id);

CREATE INDEX idx_scan_pages_scan_id ON public.scan_pages USING btree (scan_id);

CREATE INDEX idx_scan_pages_website_id ON public.scan_pages USING btree (website_id);

CREATE INDEX idx_scans_created_at ON public.scans USING btree (created_at DESC);

CREATE INDEX idx_scans_status ON public.scans USING btree (status);

CREATE INDEX idx_scans_website_id ON public.scans USING btree (website_id);

CREATE INDEX idx_usage_counters_workspace_id ON public.usage_counters USING btree (workspace_id);

CREATE INDEX idx_websites_workspace_id ON public.websites USING btree (workspace_id);

CREATE INDEX idx_workspace_members_user_id ON public.workspace_members USING btree (user_id);

CREATE INDEX idx_workspace_members_workspace_id ON public.workspace_members USING btree (workspace_id);

CREATE INDEX idx_workspaces_owner_user_id ON public.workspaces USING btree (owner_user_id);

CREATE UNIQUE INDEX profiles_email_key ON public.profiles USING btree (email);

CREATE UNIQUE INDEX profiles_pkey ON public.profiles USING btree (id);

CREATE UNIQUE INDEX recommendations_pkey ON public.recommendations USING btree (id);

CREATE UNIQUE INDEX scan_pages_pkey ON public.scan_pages USING btree (id);

CREATE UNIQUE INDEX scans_pkey ON public.scans USING btree (id);

CREATE UNIQUE INDEX site_briefs_pkey ON public.site_briefs USING btree (id);

CREATE UNIQUE INDEX site_pages_pkey ON public.site_pages USING btree (id);

CREATE UNIQUE INDEX site_projects_pkey ON public.site_projects USING btree (id);

CREATE UNIQUE INDEX subscriptions_pkey ON public.subscriptions USING btree (id);

CREATE UNIQUE INDEX subscriptions_workspace_id_key ON public.subscriptions USING btree (workspace_id);

CREATE UNIQUE INDEX template_pages_pkey ON public.template_pages USING btree (id);

CREATE UNIQUE INDEX templates_pkey ON public.templates USING btree (id);

CREATE UNIQUE INDEX usage_counters_pkey ON public.usage_counters USING btree (id);

CREATE UNIQUE INDEX usage_counters_workspace_id_period_start_period_end_key ON public.usage_counters USING btree (workspace_id, period_start, period_end);

CREATE UNIQUE INDEX websites_pkey ON public.websites USING btree (id);

CREATE UNIQUE INDEX workspace_members_pkey ON public.workspace_members USING btree (id);

CREATE UNIQUE INDEX workspace_members_workspace_id_user_id_key ON public.workspace_members USING btree (workspace_id, user_id);

CREATE UNIQUE INDEX workspaces_pkey ON public.workspaces USING btree (id);

CREATE UNIQUE INDEX workspaces_slug_key ON public.workspaces USING btree (slug);

alter table "public"."check_results" add constraint "check_results_pkey" PRIMARY KEY using index "check_results_pkey";

alter table "public"."content_blocks" add constraint "content_blocks_pkey" PRIMARY KEY using index "content_blocks_pkey";

alter table "public"."profiles" add constraint "profiles_pkey" PRIMARY KEY using index "profiles_pkey";

alter table "public"."recommendations" add constraint "recommendations_pkey" PRIMARY KEY using index "recommendations_pkey";

alter table "public"."scan_pages" add constraint "scan_pages_pkey" PRIMARY KEY using index "scan_pages_pkey";

alter table "public"."scans" add constraint "scans_pkey" PRIMARY KEY using index "scans_pkey";

alter table "public"."site_briefs" add constraint "site_briefs_pkey" PRIMARY KEY using index "site_briefs_pkey";

alter table "public"."site_pages" add constraint "site_pages_pkey" PRIMARY KEY using index "site_pages_pkey";

alter table "public"."site_projects" add constraint "site_projects_pkey" PRIMARY KEY using index "site_projects_pkey";

alter table "public"."subscriptions" add constraint "subscriptions_pkey" PRIMARY KEY using index "subscriptions_pkey";

alter table "public"."template_pages" add constraint "template_pages_pkey" PRIMARY KEY using index "template_pages_pkey";

alter table "public"."templates" add constraint "templates_pkey" PRIMARY KEY using index "templates_pkey";

alter table "public"."usage_counters" add constraint "usage_counters_pkey" PRIMARY KEY using index "usage_counters_pkey";

alter table "public"."websites" add constraint "websites_pkey" PRIMARY KEY using index "websites_pkey";

alter table "public"."workspace_members" add constraint "workspace_members_pkey" PRIMARY KEY using index "workspace_members_pkey";

alter table "public"."workspaces" add constraint "workspaces_pkey" PRIMARY KEY using index "workspaces_pkey";

alter table "public"."check_results" add constraint "check_results_page_id_fkey" FOREIGN KEY (page_id) REFERENCES public.scan_pages(id) ON DELETE CASCADE not valid;

alter table "public"."check_results" validate constraint "check_results_page_id_fkey";

alter table "public"."check_results" add constraint "check_results_scan_id_fkey" FOREIGN KEY (scan_id) REFERENCES public.scans(id) ON DELETE CASCADE not valid;

alter table "public"."check_results" validate constraint "check_results_scan_id_fkey";

alter table "public"."check_results" add constraint "check_results_severity_check" CHECK ((severity = ANY (ARRAY['low'::text, 'medium'::text, 'high'::text, 'critical'::text]))) not valid;

alter table "public"."check_results" validate constraint "check_results_severity_check";

alter table "public"."check_results" add constraint "check_results_status_check" CHECK ((status = ANY (ARRAY['pass'::text, 'warning'::text, 'fail'::text]))) not valid;

alter table "public"."check_results" validate constraint "check_results_status_check";

alter table "public"."check_results" add constraint "check_results_website_id_fkey" FOREIGN KEY (website_id) REFERENCES public.websites(id) ON DELETE CASCADE not valid;

alter table "public"."check_results" validate constraint "check_results_website_id_fkey";

alter table "public"."content_blocks" add constraint "content_blocks_site_page_id_fkey" FOREIGN KEY (site_page_id) REFERENCES public.site_pages(id) not valid;

alter table "public"."content_blocks" validate constraint "content_blocks_site_page_id_fkey";

alter table "public"."profiles" add constraint "profiles_email_key" UNIQUE using index "profiles_email_key";

alter table "public"."profiles" add constraint "profiles_id_fkey" FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."profiles" validate constraint "profiles_id_fkey";

alter table "public"."recommendations" add constraint "recommendations_page_id_fkey" FOREIGN KEY (page_id) REFERENCES public.scan_pages(id) ON DELETE CASCADE not valid;

alter table "public"."recommendations" validate constraint "recommendations_page_id_fkey";

alter table "public"."recommendations" add constraint "recommendations_priority_check" CHECK ((priority = ANY (ARRAY['low'::text, 'medium'::text, 'high'::text]))) not valid;

alter table "public"."recommendations" validate constraint "recommendations_priority_check";

alter table "public"."recommendations" add constraint "recommendations_scan_id_fkey" FOREIGN KEY (scan_id) REFERENCES public.scans(id) ON DELETE CASCADE not valid;

alter table "public"."recommendations" validate constraint "recommendations_scan_id_fkey";

alter table "public"."recommendations" add constraint "recommendations_website_id_fkey" FOREIGN KEY (website_id) REFERENCES public.websites(id) ON DELETE CASCADE not valid;

alter table "public"."recommendations" validate constraint "recommendations_website_id_fkey";

alter table "public"."scan_pages" add constraint "scan_pages_scan_id_fkey" FOREIGN KEY (scan_id) REFERENCES public.scans(id) ON DELETE CASCADE not valid;

alter table "public"."scan_pages" validate constraint "scan_pages_scan_id_fkey";

alter table "public"."scan_pages" add constraint "scan_pages_website_id_fkey" FOREIGN KEY (website_id) REFERENCES public.websites(id) ON DELETE CASCADE not valid;

alter table "public"."scan_pages" validate constraint "scan_pages_website_id_fkey";

alter table "public"."scans" add constraint "scans_created_by_user_id_fkey" FOREIGN KEY (created_by_user_id) REFERENCES public.profiles(id) ON DELETE SET NULL not valid;

alter table "public"."scans" validate constraint "scans_created_by_user_id_fkey";

alter table "public"."scans" add constraint "scans_scan_type_check" CHECK ((scan_type = ANY (ARRAY['full'::text, 'quick'::text, 'technical'::text, 'seo'::text]))) not valid;

alter table "public"."scans" validate constraint "scans_scan_type_check";

alter table "public"."scans" add constraint "scans_status_check" CHECK ((status = ANY (ARRAY['queued'::text, 'running'::text, 'completed'::text, 'failed'::text]))) not valid;

alter table "public"."scans" validate constraint "scans_status_check";

alter table "public"."scans" add constraint "scans_trigger_type_check" CHECK ((trigger_type = ANY (ARRAY['manual'::text, 'scheduled'::text, 'api'::text]))) not valid;

alter table "public"."scans" validate constraint "scans_trigger_type_check";

alter table "public"."scans" add constraint "scans_website_id_fkey" FOREIGN KEY (website_id) REFERENCES public.websites(id) ON DELETE CASCADE not valid;

alter table "public"."scans" validate constraint "scans_website_id_fkey";

alter table "public"."site_briefs" add constraint "site_briefs_site_project_id_fkey" FOREIGN KEY (site_project_id) REFERENCES public.site_projects(id) not valid;

alter table "public"."site_briefs" validate constraint "site_briefs_site_project_id_fkey";

alter table "public"."site_pages" add constraint "site_pages_site_project_id_fkey" FOREIGN KEY (site_project_id) REFERENCES public.site_projects(id) not valid;

alter table "public"."site_pages" validate constraint "site_pages_site_project_id_fkey";

alter table "public"."site_pages" add constraint "site_pages_template_page_id_fkey" FOREIGN KEY (template_page_id) REFERENCES public.template_pages(id) not valid;

alter table "public"."site_pages" validate constraint "site_pages_template_page_id_fkey";

alter table "public"."site_projects" add constraint "site_projects_template_id_fkey" FOREIGN KEY (template_id) REFERENCES public.templates(id) not valid;

alter table "public"."site_projects" validate constraint "site_projects_template_id_fkey";

alter table "public"."site_projects" add constraint "site_projects_workspace_id_fkey" FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) not valid;

alter table "public"."site_projects" validate constraint "site_projects_workspace_id_fkey";

alter table "public"."subscriptions" add constraint "subscriptions_plan_check" CHECK ((plan = ANY (ARRAY['free'::text, 'starter'::text, 'pro'::text]))) not valid;

alter table "public"."subscriptions" validate constraint "subscriptions_plan_check";

alter table "public"."subscriptions" add constraint "subscriptions_status_check" CHECK ((status = ANY (ARRAY['trialing'::text, 'active'::text, 'past_due'::text, 'canceled'::text, 'incomplete'::text]))) not valid;

alter table "public"."subscriptions" validate constraint "subscriptions_status_check";

alter table "public"."subscriptions" add constraint "subscriptions_workspace_id_fkey" FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE not valid;

alter table "public"."subscriptions" validate constraint "subscriptions_workspace_id_fkey";

alter table "public"."subscriptions" add constraint "subscriptions_workspace_id_key" UNIQUE using index "subscriptions_workspace_id_key";

alter table "public"."template_pages" add constraint "template_pages_template_id_fkey" FOREIGN KEY (template_id) REFERENCES public.templates(id) not valid;

alter table "public"."template_pages" validate constraint "template_pages_template_id_fkey";

alter table "public"."usage_counters" add constraint "usage_counters_workspace_id_fkey" FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE not valid;

alter table "public"."usage_counters" validate constraint "usage_counters_workspace_id_fkey";

alter table "public"."usage_counters" add constraint "usage_counters_workspace_id_period_start_period_end_key" UNIQUE using index "usage_counters_workspace_id_period_start_period_end_key";

alter table "public"."websites" add constraint "websites_status_check" CHECK ((status = ANY (ARRAY['active'::text, 'paused'::text, 'archived'::text]))) not valid;

alter table "public"."websites" validate constraint "websites_status_check";

alter table "public"."websites" add constraint "websites_workspace_id_fkey" FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE not valid;

alter table "public"."websites" validate constraint "websites_workspace_id_fkey";

alter table "public"."workspace_members" add constraint "workspace_members_role_check" CHECK ((role = ANY (ARRAY['owner'::text, 'admin'::text, 'editor'::text, 'viewer'::text]))) not valid;

alter table "public"."workspace_members" validate constraint "workspace_members_role_check";

alter table "public"."workspace_members" add constraint "workspace_members_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE not valid;

alter table "public"."workspace_members" validate constraint "workspace_members_user_id_fkey";

alter table "public"."workspace_members" add constraint "workspace_members_workspace_id_fkey" FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE not valid;

alter table "public"."workspace_members" validate constraint "workspace_members_workspace_id_fkey";

alter table "public"."workspace_members" add constraint "workspace_members_workspace_id_user_id_key" UNIQUE using index "workspace_members_workspace_id_user_id_key";

alter table "public"."workspaces" add constraint "workspaces_owner_user_id_fkey" FOREIGN KEY (owner_user_id) REFERENCES public.profiles(id) ON DELETE CASCADE not valid;

alter table "public"."workspaces" validate constraint "workspaces_owner_user_id_fkey";

alter table "public"."workspaces" add constraint "workspaces_plan_check" CHECK ((plan = ANY (ARRAY['free'::text, 'starter'::text, 'pro'::text]))) not valid;

alter table "public"."workspaces" validate constraint "workspaces_plan_check";

alter table "public"."workspaces" add constraint "workspaces_slug_key" UNIQUE using index "workspaces_slug_key";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.create_content_blocks(p_site_project_id uuid)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
begin

insert into content_blocks
(site_page_id, block_type, content_json, sort_order, created_at)

select
sp.id,
block.block_type,
'{}'::jsonb,
block.sort_order,
now()

from site_pages sp

join (
values
('hero',1),
('intro',2),
('services',3),
('testimonials',4),
('faq',5),
('cta',6),
('contact',7)
) as block(block_type,sort_order)

on true

where sp.site_project_id = p_site_project_id;

end;
$function$
;

CREATE OR REPLACE FUNCTION public.create_site_from_template(p_template_id uuid, p_workspace_id uuid, p_site_name text)
 RETURNS uuid
 LANGUAGE plpgsql
AS $function$

declare
v_site_project_id uuid;

begin

-- Website erstellen

insert into site_projects
(template_id, workspace_id, site_name, created_at)

values
(p_template_id, p_workspace_id, p_site_name, now())

returning id into v_site_project_id;


-- Seiten erzeugen

perform create_site_pages(v_site_project_id);


-- Content Blöcke erzeugen

perform create_content_blocks(v_site_project_id);


return v_site_project_id;

end;

$function$
;

CREATE OR REPLACE FUNCTION public.create_site_pages(p_site_project_id uuid)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
begin

insert into site_pages
(site_project_id, template_page_id, name, slug, sort_order, created_at, page_type)

select
p_site_project_id,
tp.id,
tp.name,
tp.slug,
tp.sort_order,
now(),
tp.page_type

from template_pages tp
join site_projects sp
on sp.template_id = tp.template_id
where sp.id = p_site_project_id;

end;
$function$
;

CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare
  new_workspace_id uuid;
begin

  insert into public.profiles (id, email)
  values (new.id, new.email);

  insert into public.workspaces (owner_user_id, name)
  values (new.id, 'My Workspace')
  returning id into new_workspace_id;

  insert into public.workspace_members (workspace_id, user_id, role)
  values (new_workspace_id, new.id, 'owner');

  return new;

end;
$function$
;

CREATE OR REPLACE FUNCTION public.is_workspace_admin(_workspace_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE
AS $function$
  select exists (
    select 1
    from public.workspace_members wm
    where wm.workspace_id = _workspace_id
      and wm.user_id = auth.uid()
      and wm.role in ('owner','admin')
  );
$function$
;

CREATE OR REPLACE FUNCTION public.is_workspace_member(_workspace_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE
AS $function$
  select exists (
    select 1
    from public.workspace_members wm
    where wm.workspace_id = _workspace_id
      and wm.user_id = auth.uid()
  );
$function$
;

CREATE OR REPLACE FUNCTION public.set_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
begin
  new.updated_at = now();
  return new;
end;
$function$
;

grant delete on table "public"."check_results" to "anon";

grant insert on table "public"."check_results" to "anon";

grant references on table "public"."check_results" to "anon";

grant select on table "public"."check_results" to "anon";

grant trigger on table "public"."check_results" to "anon";

grant truncate on table "public"."check_results" to "anon";

grant update on table "public"."check_results" to "anon";

grant delete on table "public"."check_results" to "authenticated";

grant insert on table "public"."check_results" to "authenticated";

grant references on table "public"."check_results" to "authenticated";

grant select on table "public"."check_results" to "authenticated";

grant trigger on table "public"."check_results" to "authenticated";

grant truncate on table "public"."check_results" to "authenticated";

grant update on table "public"."check_results" to "authenticated";

grant delete on table "public"."check_results" to "service_role";

grant insert on table "public"."check_results" to "service_role";

grant references on table "public"."check_results" to "service_role";

grant select on table "public"."check_results" to "service_role";

grant trigger on table "public"."check_results" to "service_role";

grant truncate on table "public"."check_results" to "service_role";

grant update on table "public"."check_results" to "service_role";

grant delete on table "public"."content_blocks" to "anon";

grant insert on table "public"."content_blocks" to "anon";

grant references on table "public"."content_blocks" to "anon";

grant select on table "public"."content_blocks" to "anon";

grant trigger on table "public"."content_blocks" to "anon";

grant truncate on table "public"."content_blocks" to "anon";

grant update on table "public"."content_blocks" to "anon";

grant delete on table "public"."content_blocks" to "authenticated";

grant insert on table "public"."content_blocks" to "authenticated";

grant references on table "public"."content_blocks" to "authenticated";

grant select on table "public"."content_blocks" to "authenticated";

grant trigger on table "public"."content_blocks" to "authenticated";

grant truncate on table "public"."content_blocks" to "authenticated";

grant update on table "public"."content_blocks" to "authenticated";

grant delete on table "public"."content_blocks" to "service_role";

grant insert on table "public"."content_blocks" to "service_role";

grant references on table "public"."content_blocks" to "service_role";

grant select on table "public"."content_blocks" to "service_role";

grant trigger on table "public"."content_blocks" to "service_role";

grant truncate on table "public"."content_blocks" to "service_role";

grant update on table "public"."content_blocks" to "service_role";

grant delete on table "public"."profiles" to "anon";

grant insert on table "public"."profiles" to "anon";

grant references on table "public"."profiles" to "anon";

grant select on table "public"."profiles" to "anon";

grant trigger on table "public"."profiles" to "anon";

grant truncate on table "public"."profiles" to "anon";

grant update on table "public"."profiles" to "anon";

grant delete on table "public"."profiles" to "authenticated";

grant insert on table "public"."profiles" to "authenticated";

grant references on table "public"."profiles" to "authenticated";

grant select on table "public"."profiles" to "authenticated";

grant trigger on table "public"."profiles" to "authenticated";

grant truncate on table "public"."profiles" to "authenticated";

grant update on table "public"."profiles" to "authenticated";

grant delete on table "public"."profiles" to "service_role";

grant insert on table "public"."profiles" to "service_role";

grant references on table "public"."profiles" to "service_role";

grant select on table "public"."profiles" to "service_role";

grant trigger on table "public"."profiles" to "service_role";

grant truncate on table "public"."profiles" to "service_role";

grant update on table "public"."profiles" to "service_role";

grant delete on table "public"."recommendations" to "anon";

grant insert on table "public"."recommendations" to "anon";

grant references on table "public"."recommendations" to "anon";

grant select on table "public"."recommendations" to "anon";

grant trigger on table "public"."recommendations" to "anon";

grant truncate on table "public"."recommendations" to "anon";

grant update on table "public"."recommendations" to "anon";

grant delete on table "public"."recommendations" to "authenticated";

grant insert on table "public"."recommendations" to "authenticated";

grant references on table "public"."recommendations" to "authenticated";

grant select on table "public"."recommendations" to "authenticated";

grant trigger on table "public"."recommendations" to "authenticated";

grant truncate on table "public"."recommendations" to "authenticated";

grant update on table "public"."recommendations" to "authenticated";

grant delete on table "public"."recommendations" to "service_role";

grant insert on table "public"."recommendations" to "service_role";

grant references on table "public"."recommendations" to "service_role";

grant select on table "public"."recommendations" to "service_role";

grant trigger on table "public"."recommendations" to "service_role";

grant truncate on table "public"."recommendations" to "service_role";

grant update on table "public"."recommendations" to "service_role";

grant delete on table "public"."scan_pages" to "anon";

grant insert on table "public"."scan_pages" to "anon";

grant references on table "public"."scan_pages" to "anon";

grant select on table "public"."scan_pages" to "anon";

grant trigger on table "public"."scan_pages" to "anon";

grant truncate on table "public"."scan_pages" to "anon";

grant update on table "public"."scan_pages" to "anon";

grant delete on table "public"."scan_pages" to "authenticated";

grant insert on table "public"."scan_pages" to "authenticated";

grant references on table "public"."scan_pages" to "authenticated";

grant select on table "public"."scan_pages" to "authenticated";

grant trigger on table "public"."scan_pages" to "authenticated";

grant truncate on table "public"."scan_pages" to "authenticated";

grant update on table "public"."scan_pages" to "authenticated";

grant delete on table "public"."scan_pages" to "service_role";

grant insert on table "public"."scan_pages" to "service_role";

grant references on table "public"."scan_pages" to "service_role";

grant select on table "public"."scan_pages" to "service_role";

grant trigger on table "public"."scan_pages" to "service_role";

grant truncate on table "public"."scan_pages" to "service_role";

grant update on table "public"."scan_pages" to "service_role";

grant delete on table "public"."scans" to "anon";

grant insert on table "public"."scans" to "anon";

grant references on table "public"."scans" to "anon";

grant select on table "public"."scans" to "anon";

grant trigger on table "public"."scans" to "anon";

grant truncate on table "public"."scans" to "anon";

grant update on table "public"."scans" to "anon";

grant delete on table "public"."scans" to "authenticated";

grant insert on table "public"."scans" to "authenticated";

grant references on table "public"."scans" to "authenticated";

grant select on table "public"."scans" to "authenticated";

grant trigger on table "public"."scans" to "authenticated";

grant truncate on table "public"."scans" to "authenticated";

grant update on table "public"."scans" to "authenticated";

grant delete on table "public"."scans" to "service_role";

grant insert on table "public"."scans" to "service_role";

grant references on table "public"."scans" to "service_role";

grant select on table "public"."scans" to "service_role";

grant trigger on table "public"."scans" to "service_role";

grant truncate on table "public"."scans" to "service_role";

grant update on table "public"."scans" to "service_role";

grant delete on table "public"."site_briefs" to "anon";

grant insert on table "public"."site_briefs" to "anon";

grant references on table "public"."site_briefs" to "anon";

grant select on table "public"."site_briefs" to "anon";

grant trigger on table "public"."site_briefs" to "anon";

grant truncate on table "public"."site_briefs" to "anon";

grant update on table "public"."site_briefs" to "anon";

grant delete on table "public"."site_briefs" to "authenticated";

grant insert on table "public"."site_briefs" to "authenticated";

grant references on table "public"."site_briefs" to "authenticated";

grant select on table "public"."site_briefs" to "authenticated";

grant trigger on table "public"."site_briefs" to "authenticated";

grant truncate on table "public"."site_briefs" to "authenticated";

grant update on table "public"."site_briefs" to "authenticated";

grant delete on table "public"."site_briefs" to "service_role";

grant insert on table "public"."site_briefs" to "service_role";

grant references on table "public"."site_briefs" to "service_role";

grant select on table "public"."site_briefs" to "service_role";

grant trigger on table "public"."site_briefs" to "service_role";

grant truncate on table "public"."site_briefs" to "service_role";

grant update on table "public"."site_briefs" to "service_role";

grant delete on table "public"."site_pages" to "anon";

grant insert on table "public"."site_pages" to "anon";

grant references on table "public"."site_pages" to "anon";

grant select on table "public"."site_pages" to "anon";

grant trigger on table "public"."site_pages" to "anon";

grant truncate on table "public"."site_pages" to "anon";

grant update on table "public"."site_pages" to "anon";

grant delete on table "public"."site_pages" to "authenticated";

grant insert on table "public"."site_pages" to "authenticated";

grant references on table "public"."site_pages" to "authenticated";

grant select on table "public"."site_pages" to "authenticated";

grant trigger on table "public"."site_pages" to "authenticated";

grant truncate on table "public"."site_pages" to "authenticated";

grant update on table "public"."site_pages" to "authenticated";

grant delete on table "public"."site_pages" to "service_role";

grant insert on table "public"."site_pages" to "service_role";

grant references on table "public"."site_pages" to "service_role";

grant select on table "public"."site_pages" to "service_role";

grant trigger on table "public"."site_pages" to "service_role";

grant truncate on table "public"."site_pages" to "service_role";

grant update on table "public"."site_pages" to "service_role";

grant delete on table "public"."site_projects" to "anon";

grant insert on table "public"."site_projects" to "anon";

grant references on table "public"."site_projects" to "anon";

grant select on table "public"."site_projects" to "anon";

grant trigger on table "public"."site_projects" to "anon";

grant truncate on table "public"."site_projects" to "anon";

grant update on table "public"."site_projects" to "anon";

grant delete on table "public"."site_projects" to "authenticated";

grant insert on table "public"."site_projects" to "authenticated";

grant references on table "public"."site_projects" to "authenticated";

grant select on table "public"."site_projects" to "authenticated";

grant trigger on table "public"."site_projects" to "authenticated";

grant truncate on table "public"."site_projects" to "authenticated";

grant update on table "public"."site_projects" to "authenticated";

grant delete on table "public"."site_projects" to "service_role";

grant insert on table "public"."site_projects" to "service_role";

grant references on table "public"."site_projects" to "service_role";

grant select on table "public"."site_projects" to "service_role";

grant trigger on table "public"."site_projects" to "service_role";

grant truncate on table "public"."site_projects" to "service_role";

grant update on table "public"."site_projects" to "service_role";

grant delete on table "public"."subscriptions" to "anon";

grant insert on table "public"."subscriptions" to "anon";

grant references on table "public"."subscriptions" to "anon";

grant select on table "public"."subscriptions" to "anon";

grant trigger on table "public"."subscriptions" to "anon";

grant truncate on table "public"."subscriptions" to "anon";

grant update on table "public"."subscriptions" to "anon";

grant delete on table "public"."subscriptions" to "authenticated";

grant insert on table "public"."subscriptions" to "authenticated";

grant references on table "public"."subscriptions" to "authenticated";

grant select on table "public"."subscriptions" to "authenticated";

grant trigger on table "public"."subscriptions" to "authenticated";

grant truncate on table "public"."subscriptions" to "authenticated";

grant update on table "public"."subscriptions" to "authenticated";

grant delete on table "public"."subscriptions" to "service_role";

grant insert on table "public"."subscriptions" to "service_role";

grant references on table "public"."subscriptions" to "service_role";

grant select on table "public"."subscriptions" to "service_role";

grant trigger on table "public"."subscriptions" to "service_role";

grant truncate on table "public"."subscriptions" to "service_role";

grant update on table "public"."subscriptions" to "service_role";

grant delete on table "public"."template_pages" to "anon";

grant insert on table "public"."template_pages" to "anon";

grant references on table "public"."template_pages" to "anon";

grant select on table "public"."template_pages" to "anon";

grant trigger on table "public"."template_pages" to "anon";

grant truncate on table "public"."template_pages" to "anon";

grant update on table "public"."template_pages" to "anon";

grant delete on table "public"."template_pages" to "authenticated";

grant insert on table "public"."template_pages" to "authenticated";

grant references on table "public"."template_pages" to "authenticated";

grant select on table "public"."template_pages" to "authenticated";

grant trigger on table "public"."template_pages" to "authenticated";

grant truncate on table "public"."template_pages" to "authenticated";

grant update on table "public"."template_pages" to "authenticated";

grant delete on table "public"."template_pages" to "service_role";

grant insert on table "public"."template_pages" to "service_role";

grant references on table "public"."template_pages" to "service_role";

grant select on table "public"."template_pages" to "service_role";

grant trigger on table "public"."template_pages" to "service_role";

grant truncate on table "public"."template_pages" to "service_role";

grant update on table "public"."template_pages" to "service_role";

grant delete on table "public"."templates" to "anon";

grant insert on table "public"."templates" to "anon";

grant references on table "public"."templates" to "anon";

grant select on table "public"."templates" to "anon";

grant trigger on table "public"."templates" to "anon";

grant truncate on table "public"."templates" to "anon";

grant update on table "public"."templates" to "anon";

grant delete on table "public"."templates" to "authenticated";

grant insert on table "public"."templates" to "authenticated";

grant references on table "public"."templates" to "authenticated";

grant select on table "public"."templates" to "authenticated";

grant trigger on table "public"."templates" to "authenticated";

grant truncate on table "public"."templates" to "authenticated";

grant update on table "public"."templates" to "authenticated";

grant delete on table "public"."templates" to "service_role";

grant insert on table "public"."templates" to "service_role";

grant references on table "public"."templates" to "service_role";

grant select on table "public"."templates" to "service_role";

grant trigger on table "public"."templates" to "service_role";

grant truncate on table "public"."templates" to "service_role";

grant update on table "public"."templates" to "service_role";

grant delete on table "public"."usage_counters" to "anon";

grant insert on table "public"."usage_counters" to "anon";

grant references on table "public"."usage_counters" to "anon";

grant select on table "public"."usage_counters" to "anon";

grant trigger on table "public"."usage_counters" to "anon";

grant truncate on table "public"."usage_counters" to "anon";

grant update on table "public"."usage_counters" to "anon";

grant delete on table "public"."usage_counters" to "authenticated";

grant insert on table "public"."usage_counters" to "authenticated";

grant references on table "public"."usage_counters" to "authenticated";

grant select on table "public"."usage_counters" to "authenticated";

grant trigger on table "public"."usage_counters" to "authenticated";

grant truncate on table "public"."usage_counters" to "authenticated";

grant update on table "public"."usage_counters" to "authenticated";

grant delete on table "public"."usage_counters" to "service_role";

grant insert on table "public"."usage_counters" to "service_role";

grant references on table "public"."usage_counters" to "service_role";

grant select on table "public"."usage_counters" to "service_role";

grant trigger on table "public"."usage_counters" to "service_role";

grant truncate on table "public"."usage_counters" to "service_role";

grant update on table "public"."usage_counters" to "service_role";

grant delete on table "public"."websites" to "anon";

grant insert on table "public"."websites" to "anon";

grant references on table "public"."websites" to "anon";

grant select on table "public"."websites" to "anon";

grant trigger on table "public"."websites" to "anon";

grant truncate on table "public"."websites" to "anon";

grant update on table "public"."websites" to "anon";

grant delete on table "public"."websites" to "authenticated";

grant insert on table "public"."websites" to "authenticated";

grant references on table "public"."websites" to "authenticated";

grant select on table "public"."websites" to "authenticated";

grant trigger on table "public"."websites" to "authenticated";

grant truncate on table "public"."websites" to "authenticated";

grant update on table "public"."websites" to "authenticated";

grant delete on table "public"."websites" to "service_role";

grant insert on table "public"."websites" to "service_role";

grant references on table "public"."websites" to "service_role";

grant select on table "public"."websites" to "service_role";

grant trigger on table "public"."websites" to "service_role";

grant truncate on table "public"."websites" to "service_role";

grant update on table "public"."websites" to "service_role";

grant delete on table "public"."workspace_members" to "anon";

grant insert on table "public"."workspace_members" to "anon";

grant references on table "public"."workspace_members" to "anon";

grant select on table "public"."workspace_members" to "anon";

grant trigger on table "public"."workspace_members" to "anon";

grant truncate on table "public"."workspace_members" to "anon";

grant update on table "public"."workspace_members" to "anon";

grant delete on table "public"."workspace_members" to "authenticated";

grant insert on table "public"."workspace_members" to "authenticated";

grant references on table "public"."workspace_members" to "authenticated";

grant select on table "public"."workspace_members" to "authenticated";

grant trigger on table "public"."workspace_members" to "authenticated";

grant truncate on table "public"."workspace_members" to "authenticated";

grant update on table "public"."workspace_members" to "authenticated";

grant delete on table "public"."workspace_members" to "service_role";

grant insert on table "public"."workspace_members" to "service_role";

grant references on table "public"."workspace_members" to "service_role";

grant select on table "public"."workspace_members" to "service_role";

grant trigger on table "public"."workspace_members" to "service_role";

grant truncate on table "public"."workspace_members" to "service_role";

grant update on table "public"."workspace_members" to "service_role";

grant delete on table "public"."workspaces" to "anon";

grant insert on table "public"."workspaces" to "anon";

grant references on table "public"."workspaces" to "anon";

grant select on table "public"."workspaces" to "anon";

grant trigger on table "public"."workspaces" to "anon";

grant truncate on table "public"."workspaces" to "anon";

grant update on table "public"."workspaces" to "anon";

grant delete on table "public"."workspaces" to "authenticated";

grant insert on table "public"."workspaces" to "authenticated";

grant references on table "public"."workspaces" to "authenticated";

grant select on table "public"."workspaces" to "authenticated";

grant trigger on table "public"."workspaces" to "authenticated";

grant truncate on table "public"."workspaces" to "authenticated";

grant update on table "public"."workspaces" to "authenticated";

grant delete on table "public"."workspaces" to "service_role";

grant insert on table "public"."workspaces" to "service_role";

grant references on table "public"."workspaces" to "service_role";

grant select on table "public"."workspaces" to "service_role";

grant trigger on table "public"."workspaces" to "service_role";

grant truncate on table "public"."workspaces" to "service_role";

grant update on table "public"."workspaces" to "service_role";


  create policy "check_results_insert_admin"
  on "public"."check_results"
  as permissive
  for insert
  to authenticated
with check ((EXISTS ( SELECT 1
   FROM public.websites w
  WHERE ((w.id = check_results.website_id) AND public.is_workspace_admin(w.workspace_id)))));



  create policy "check_results_select_member"
  on "public"."check_results"
  as permissive
  for select
  to authenticated
using ((EXISTS ( SELECT 1
   FROM public.websites w
  WHERE ((w.id = check_results.website_id) AND public.is_workspace_member(w.workspace_id)))));



  create policy "profiles_insert_own"
  on "public"."profiles"
  as permissive
  for insert
  to authenticated
with check ((auth.uid() = id));



  create policy "profiles_select_own"
  on "public"."profiles"
  as permissive
  for select
  to authenticated
using ((auth.uid() = id));



  create policy "profiles_update_own"
  on "public"."profiles"
  as permissive
  for update
  to authenticated
using ((auth.uid() = id))
with check ((auth.uid() = id));



  create policy "recommendations_insert_admin"
  on "public"."recommendations"
  as permissive
  for insert
  to authenticated
with check ((EXISTS ( SELECT 1
   FROM public.websites w
  WHERE ((w.id = recommendations.website_id) AND public.is_workspace_admin(w.workspace_id)))));



  create policy "recommendations_select_member"
  on "public"."recommendations"
  as permissive
  for select
  to authenticated
using ((EXISTS ( SELECT 1
   FROM public.websites w
  WHERE ((w.id = recommendations.website_id) AND public.is_workspace_member(w.workspace_id)))));



  create policy "scan_pages_insert_admin"
  on "public"."scan_pages"
  as permissive
  for insert
  to authenticated
with check ((EXISTS ( SELECT 1
   FROM public.websites w
  WHERE ((w.id = scan_pages.website_id) AND public.is_workspace_admin(w.workspace_id)))));



  create policy "scan_pages_select_member"
  on "public"."scan_pages"
  as permissive
  for select
  to authenticated
using ((EXISTS ( SELECT 1
   FROM public.websites w
  WHERE ((w.id = scan_pages.website_id) AND public.is_workspace_member(w.workspace_id)))));



  create policy "scans_insert_admin"
  on "public"."scans"
  as permissive
  for insert
  to authenticated
with check ((EXISTS ( SELECT 1
   FROM public.websites w
  WHERE ((w.id = scans.website_id) AND public.is_workspace_admin(w.workspace_id)))));



  create policy "scans_select_member"
  on "public"."scans"
  as permissive
  for select
  to authenticated
using ((EXISTS ( SELECT 1
   FROM public.websites w
  WHERE ((w.id = scans.website_id) AND public.is_workspace_member(w.workspace_id)))));



  create policy "scans_update_admin"
  on "public"."scans"
  as permissive
  for update
  to authenticated
using ((EXISTS ( SELECT 1
   FROM public.websites w
  WHERE ((w.id = scans.website_id) AND public.is_workspace_admin(w.workspace_id)))))
with check ((EXISTS ( SELECT 1
   FROM public.websites w
  WHERE ((w.id = scans.website_id) AND public.is_workspace_admin(w.workspace_id)))));



  create policy "subscriptions_insert_admin"
  on "public"."subscriptions"
  as permissive
  for insert
  to authenticated
with check (public.is_workspace_admin(workspace_id));



  create policy "subscriptions_select_member"
  on "public"."subscriptions"
  as permissive
  for select
  to authenticated
using (public.is_workspace_member(workspace_id));



  create policy "subscriptions_update_admin"
  on "public"."subscriptions"
  as permissive
  for update
  to authenticated
using (public.is_workspace_admin(workspace_id))
with check (public.is_workspace_admin(workspace_id));



  create policy "usage_counters_insert_admin"
  on "public"."usage_counters"
  as permissive
  for insert
  to authenticated
with check (public.is_workspace_admin(workspace_id));



  create policy "usage_counters_select_member"
  on "public"."usage_counters"
  as permissive
  for select
  to authenticated
using (public.is_workspace_member(workspace_id));



  create policy "usage_counters_update_admin"
  on "public"."usage_counters"
  as permissive
  for update
  to authenticated
using (public.is_workspace_admin(workspace_id))
with check (public.is_workspace_admin(workspace_id));



  create policy "websites_delete_admin"
  on "public"."websites"
  as permissive
  for delete
  to authenticated
using (public.is_workspace_admin(workspace_id));



  create policy "websites_insert_admin"
  on "public"."websites"
  as permissive
  for insert
  to authenticated
with check (public.is_workspace_admin(workspace_id));



  create policy "websites_select_member"
  on "public"."websites"
  as permissive
  for select
  to authenticated
using (public.is_workspace_member(workspace_id));



  create policy "websites_update_admin"
  on "public"."websites"
  as permissive
  for update
  to authenticated
using (public.is_workspace_admin(workspace_id))
with check (public.is_workspace_admin(workspace_id));



  create policy "workspace_members_delete_admin"
  on "public"."workspace_members"
  as permissive
  for delete
  to authenticated
using (public.is_workspace_admin(workspace_id));



  create policy "workspace_members_insert_admin"
  on "public"."workspace_members"
  as permissive
  for insert
  to authenticated
with check (public.is_workspace_admin(workspace_id));



  create policy "workspace_members_select_member"
  on "public"."workspace_members"
  as permissive
  for select
  to authenticated
using (public.is_workspace_member(workspace_id));



  create policy "workspace_members_update_admin"
  on "public"."workspace_members"
  as permissive
  for update
  to authenticated
using (public.is_workspace_admin(workspace_id))
with check (public.is_workspace_admin(workspace_id));



  create policy "workspaces_insert_owner"
  on "public"."workspaces"
  as permissive
  for insert
  to authenticated
with check ((owner_user_id = auth.uid()));



  create policy "workspaces_select_member"
  on "public"."workspaces"
  as permissive
  for select
  to authenticated
using (public.is_workspace_member(id));



  create policy "workspaces_update_admin"
  on "public"."workspaces"
  as permissive
  for update
  to authenticated
using (public.is_workspace_admin(id))
with check (public.is_workspace_admin(id));


CREATE TRIGGER set_profiles_updated_at BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER set_subscriptions_updated_at BEFORE UPDATE ON public.subscriptions FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER set_websites_updated_at BEFORE UPDATE ON public.websites FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER set_workspaces_updated_at BEFORE UPDATE ON public.workspaces FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


