"use client";

import { Loader } from "lucide-react";
import { useSearchParams } from "next/navigation";
import { useQuery } from "@tanstack/react-query";
import { TableSelector } from "./TableSelector";
import { TablesViewer } from "./TablesViewer";

export function DataExplorer() {
  const searchParams = useSearchParams();
  const { data: tables, isLoading } = useQuery({
    queryKey: ["tables"],
    queryFn: async () => {
      const response = await fetch("/api/tables");
      const json = await response.json();
      if (!response.ok) {
        throw new Error(json.error);
      }

      return json;
    },
    select: (data) => data.tables.map((table: { name: string }) => table.name),
    refetchInterval: 15000,
    throwOnError: true,
    retry: false,
  });
  const selectedTable = searchParams.get("table") || (tables?.length > 0 ? tables[0] : null);

  if (isLoading) {
    return <Loader className="animate-spin" />;
  }

  return (
    <>
      <TableSelector value={selectedTable} options={tables} />
      <TablesViewer table={selectedTable} />
    </>
  );
}